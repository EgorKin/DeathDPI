import Foundation
import Network

class DPIManager {
    static let shared = DPIManager()
    private var connection: NWConnection?
    private var listener: NWListener?
    private var proxyServer: ProxyServer?
    
    private init() {}
    
    func startConnection(with settings: Settings) -> Bool {
        guard setupConnection(settings) else {
            LogManager.shared.log("Failed to setup connection")
            return false
        }
        
        if settings.mode == .vpn {
            return startVPNConnection(settings)
        } else {
            return startProxyConnection(settings)
        }
    }
    
    private func setupConnection(_ settings: Settings) -> Bool {
        // Initialize network parameters based on settings
        let parameters = NWParameters()
        parameters.defaultProtocolStack.internetProtocol = .tcp
        
        if settings.ipv6Enabled {
            parameters.defaultProtocolStack.internetProtocol = .ip
        }
        
        // Setup DNS
        if let endpoint = NWEndpoint.hostPort(host: .init(settings.dns), port: 53) as? NWEndpoint {
            parameters.defaultPath.defaultGateway = endpoint
        }
        
        return true
    }
    
    private func startVPNConnection(_ settings: Settings) -> Bool {
        // Save settings to app group container for VPN extension
        saveSettingsToContainer(settings)
        
        // Configure and start VPN
        VPNManager.shared.configureVPN(with: settings)
        VPNManager.shared.startVPN()
        
        return true
    }
    
    private func saveSettingsToContainer(_ settings: Settings) {
        let groupId = "group.com.deathdpi"
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId) else {
            return
        }
        
        let settingsURL = containerURL.appendingPathComponent("settings.json")
        if let encoded = try? JSONEncoder().encode(settings) {
            try? encoded.write(to: settingsURL)
        }
    }
    
    private func startProxyConnection(_ settings: Settings) -> Bool {
        proxyServer = ProxyServer(settings: settings)
        
        do {
            try proxyServer?.start()
            return true
        } catch {
            LogManager.shared.log("Failed to start proxy server: \(error.localizedDescription)", level: .error)
            return false
        }
    }
    
    func stopConnection() {
        if appState.settings.mode == .vpn {
            VPNManager.shared.stopVPN()
        } else {
            proxyServer?.stop()
        }
        
        connection?.cancel()
        listener?.cancel()
    }
    
    // Additional DPI-specific methods will be implemented here
} 