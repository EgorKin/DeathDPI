import Foundation
import NetworkExtension

class NetworkExtensionHelper {
    static let shared = NetworkExtensionHelper()
    
    private init() {}
    
    func requestPermissions() async throws {
        // Request VPN permissions
        try await NEVPNManager.shared().loadFromPreferences()
        
        // Request Network Extension permissions
        if #available(iOS 15.0, *) {
            try await NEHotspotConfigurationManager.shared.requestAuthorization()
        }
    }
    
    func checkVPNStatus() -> Bool {
        let status = NEVPNManager.shared().connection.status
        return status == .connected || status == .connecting
    }
    
    func setupVPNConfiguration() async throws {
        let manager = NEVPNManager.shared()
        try await manager.loadFromPreferences()
        
        // Configure VPN protocol
        let proto = NEVPNProtocolIKEv2()
        proto.username = "deathdpi"
        proto.serverAddress = "127.0.0.1"
        proto.remoteIdentifier = "com.deathdpi"
        proto.localIdentifier = "client.deathdpi"
        
        manager.protocolConfiguration = proto
        manager.localizedDescription = "DeathDPI VPN"
        manager.isEnabled = true
        
        try await manager.saveToPreferences()
    }
} 