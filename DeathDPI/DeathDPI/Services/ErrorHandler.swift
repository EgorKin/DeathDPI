import Foundation

enum DPIError: Error {
    case vpnConfigurationFailed
    case proxyStartFailed
    case connectionFailed
    case packetManipulationFailed
    case settingsError
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .vpnConfigurationFailed:
            return "Failed to configure VPN"
        case .proxyStartFailed:
            return "Failed to start proxy server"
        case .connectionFailed:
            return "Connection failed"
        case .packetManipulationFailed:
            return "Failed to manipulate packet"
        case .settingsError:
            return "Settings error"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class ErrorHandler {
    static let shared = ErrorHandler()
    private init() {}
    
    func handle(_ error: DPIError) {
        LogManager.shared.log(error.localizedDescription, level: .error)
        
        // Attempt recovery based on error type
        switch error {
        case .vpnConfigurationFailed:
            attemptVPNRecovery()
        case .proxyStartFailed:
            attemptProxyRecovery()
        case .connectionFailed:
            attemptConnectionRecovery()
        default:
            break
        }
    }
    
    private func attemptVPNRecovery() {
        VPNManager.shared.stopVPN()
        // Wait a bit before trying again
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            VPNManager.shared.configureVPN(with: AppState().settings)
        }
    }
    
    private func attemptProxyRecovery() {
        // Stop the current proxy server
        DPIManager.shared.stopConnection()
        
        // Wait a bit and try to restart
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            _ = DPIManager.shared.startConnection(with: AppState().settings)
        }
    }
    
    private func attemptConnectionRecovery() {
        NetworkMonitor.shared.stopMonitoring()
        NetworkMonitor.shared.startMonitoring()
        
        // Wait for network to stabilize
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            _ = DPIManager.shared.startConnection(with: AppState().settings)
        }
    }
} 