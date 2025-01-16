import NetworkExtension
import Network

class PacketTunnelProvider: NEPacketTunnelProvider {
    private var packetFlow: NEPacketTunnelFlow { self.packetFlow }
    private let packetManipulator = PacketManipulator.shared
    private var settings: Settings?
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        // Load settings from app group container
        if let settingsData = loadSettings(),
           let decodedSettings = try? JSONDecoder().decode(Settings.self, from: settingsData) {
            settings = decodedSettings
        }
        
        // Configure network settings
        let networkSettings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: settings?.proxySettings.listenAddress ?? "127.0.0.1")
        networkSettings.mtu = NSNumber(value: settings?.proxySettings.bufferSize ?? 1500)
        
        // Configure DNS settings
        let dnsSettings = NEDNSSettings(servers: [settings?.dns ?? "1.1.1.1"])
        networkSettings.dnsSettings = dnsSettings
        
        // Apply network settings
        setTunnelNetworkSettings(networkSettings) { [weak self] error in
            if let error = error {
                completionHandler(error)
                return
            }
            
            self?.startPacketForwarding()
            completionHandler(nil)
        }
    }
    
    private func startPacketForwarding() {
        packetFlow.readPackets { [weak self] packets, protocols in
            self?.handlePackets(packets, protocols: protocols)
        }
    }
    
    private func handlePackets(_ packets: [Data], protocols: [NSNumber]) {
        guard let settings = settings else { return }
        
        for (packet, proto) in zip(packets, protocols) {
            let manipulatedPackets: [Data]
            
            switch proto.intValue {
            case AF_INET, AF_INET6:
                if let httpPacket = extractHTTPPacket(from: packet) {
                    manipulatedPackets = [packetManipulator.manipulateHTTPPacket(httpPacket, settings: settings.protocolSettings)]
                    updateStatistics(bytesIn: packet.count, bytesOut: manipulatedPackets[0].count, manipulated: true)
                } else if let httpsPacket = extractHTTPSPacket(from: packet) {
                    manipulatedPackets = packetManipulator.manipulateHTTPSPacket(httpsPacket, settings: settings.protocolSettings)
                    updateStatistics(bytesIn: packet.count, bytesOut: manipulatedPackets.reduce(0) { $0 + $1.count }, manipulated: true)
                } else {
                    manipulatedPackets = [packet]
                    updateStatistics(bytesIn: packet.count, bytesOut: packet.count, manipulated: false)
                }
                
                packetFlow.writePackets(manipulatedPackets, withProtocols: Array(repeating: proto, count: manipulatedPackets.count))
            default:
                break
            }
        }
        
        startPacketForwarding()
    }
    
    private func updateStatistics(bytesIn: Int, bytesOut: Int, manipulated: Bool) {
        DispatchQueue.main.async {
            let stats = NetworkStatistics.shared
            stats.updateBytesIn(bytesIn)
            stats.updateBytesOut(bytesOut)
            if manipulated {
                stats.packetManipulated()
            }
        }
    }
    
    private func extractHTTPPacket(from packet: Data) -> Data? {
        let httpMethods = ["GET", "POST", "HEAD", "PUT", "DELETE", "OPTIONS", "TRACE", "CONNECT"]
        let packetString = String(data: packet, encoding: .ascii) ?? ""
        
        // Check if packet starts with HTTP method
        for method in httpMethods {
            if packetString.hasPrefix(method) {
                return packet
            }
        }
        
        return nil
    }
    
    private func extractHTTPSPacket(from packet: Data) -> Data? {
        guard packet.count >= 5 else { return nil }
        
        // Check for TLS handshake
        let recordType = packet[0]
        let version = (UInt16(packet[1]) << 8) | UInt16(packet[2])
        
        // Check if it's a TLS handshake (type 22) with valid version
        if recordType == 22 && (version >= 0x0301 && version <= 0x0304) {
            return packet
        }
        
        return nil
    }
    
    private func loadSettings() -> Data? {
        let groupId = "group.com.deathdpi"
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId) else {
            return nil
        }
        
        let settingsURL = containerURL.appendingPathComponent("settings.json")
        return try? Data(contentsOf: settingsURL)
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Clean up resources
        completionHandler()
    }
} 