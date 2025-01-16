import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private var pathMonitor: NWPathMonitor?
    @Published var isConnected = false
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        pathMonitor = NWPathMonitor()
        pathMonitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.logNetworkChange(path)
            }
        }
        
        pathMonitor?.start(queue: DispatchQueue.global())
    }
    
    private func logNetworkChange(_ path: NWPath) {
        let interfaces = path.availableInterfaces.map { $0.name }.joined(separator: ", ")
        LogManager.shared.log("Network status changed: \(path.status), interfaces: \(interfaces)")
    }
    
    func stopMonitoring() {
        pathMonitor?.cancel()
        pathMonitor = nil
    }
} 