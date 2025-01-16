import Foundation

class NetworkStatistics: ObservableObject {
    @Published var bytesIn: UInt64 = 0
    @Published var bytesOut: UInt64 = 0
    @Published var activeConnections: Int = 0
    @Published var totalConnections: Int = 0
    @Published var packetsManipulated: Int = 0
    
    static let shared = NetworkStatistics()
    private init() {}
    
    func updateBytesIn(_ bytes: Int) {
        bytesIn += UInt64(bytes)
    }
    
    func updateBytesOut(_ bytes: Int) {
        bytesOut += UInt64(bytes)
    }
    
    func connectionStarted() {
        activeConnections += 1
        totalConnections += 1
    }
    
    func connectionEnded() {
        activeConnections -= 1
    }
    
    func packetManipulated() {
        packetsManipulated += 1
    }
    
    func reset() {
        bytesIn = 0
        bytesOut = 0
        activeConnections = 0
        totalConnections = 0
        packetsManipulated = 0
    }
} 