import Foundation
import Combine

class AppState: ObservableObject {
    @Published var isConnected: Bool = false
    @Published var currentIP: String = "127.0.0.1:1080"
    @Published var settings = Settings()
    @Published var logs: [LogEntry] = []
    
    func connect() {
        Task {
            do {
                try await NetworkExtensionHelper.shared.requestPermissions()
                
                // Initialize DPI connection
                let dpiManager = DPIManager.shared
                isConnected = dpiManager.startConnection(with: settings)
                
                if isConnected {
                    NotificationManager.shared.notifyConnectionStatus(true)
                } else {
                    throw DPIError.connectionFailed
                }
            } catch {
                if let dpiError = error as? DPIError {
                    ErrorHandler.shared.handle(dpiError)
                    NotificationManager.shared.notifyError(dpiError)
                } else {
                    let networkError = DPIError.networkError(error)
                    ErrorHandler.shared.handle(networkError)
                    NotificationManager.shared.notifyError(networkError)
                }
            }
        }
    }
    
    func disconnect() {
        DPIManager.shared.stopConnection()
        isConnected = false
        NotificationManager.shared.notifyConnectionStatus(false)
        NetworkStatistics.shared.reset()
    }
    
    func saveLogs() -> URL? {
        return LogManager.shared.exportLogs(logs)
    }
}

struct Settings: Codable {
    var theme: Theme = .system
    var mode: ConnectionMode = .vpn
    var dns: String = "1.1.1.1"
    var ipv6Enabled: Bool = false
    var useCommandLine: Bool = false
    var commandLineArgs: String = ""
    
    // UI Editor Settings
    var proxySettings = ProxySettings()
    var desyncSettings = DesyncSettings()
    var protocolSettings = ProtocolSettings()
    
    enum Theme: String, Codable {
        case system, light, dark
    }
    
    enum ConnectionMode: String, Codable {
        case vpn, proxy
    }
} 