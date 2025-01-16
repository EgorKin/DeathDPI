import Foundation
import NetworkExtension

class VPNManager {
    static let shared = VPNManager()
    private var manager: NETunnelProviderManager?
    
    private init() {
        loadVPNConfiguration()
    }
    
    private func loadVPNConfiguration() {
        NETunnelProviderManager.loadAllFromPreferences { [weak self] managers, error in
            if let error = error {
                LogManager.shared.log("Failed to load VPN configurations: \(error.localizedDescription)", level: .error)
                return
            }
            
            self?.manager = managers?.first ?? NETunnelProviderManager()
        }
    }
    
    func configureVPN(with settings: Settings) {
        let proto = NETunnelProviderProtocol()
        proto.providerBundleIdentifier = "com.deathdpi.vpnextension"
        proto.serverAddress = settings.proxySettings.listenAddress
        
        manager?.protocolConfiguration = proto
        manager?.localizedDescription = "DeathDPI VPN"
        manager?.isEnabled = true
        
        manager?.saveToPreferences { [weak self] error in
            if let error = error {
                LogManager.shared.log("Failed to save VPN configuration: \(error.localizedDescription)", level: .error)
                return
            }
            
            self?.loadVPNConfiguration()
        }
    }
    
    func startVPN() {
        do {
            try manager?.connection.startVPNTunnel()
        } catch {
            LogManager.shared.log("Failed to start VPN: \(error.localizedDescription)", level: .error)
        }
    }
    
    func stopVPN() {
        manager?.connection.stopVPNTunnel()
    }
} 