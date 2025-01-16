import Foundation

struct ProxySettings: Codable {
    var listenAddress: String = "127.0.0.1"
    var port: Int = 1080
    var maxConnections: Int = 1000
    var bufferSize: Int = 16384
    var noDomain: Bool = false
    var tcpFastOpen: Bool = false
}

struct DesyncSettings: Codable {
    enum HostMode: String, Codable {
        case disable, blacklist, whitelist
    }
    
    enum DesyncMethod: String, Codable {
        case none, split, disorder, fake, outOfBand, disorderedOutOfBand
    }
    
    var hostMode: HostMode = .disable
    var defaultTTL: Int = 0
    var desyncMethod: DesyncMethod = .disorder
    var splitPosition: Int = 1
    var splitAtHost: Bool = false
    var dropSACK: Bool = false
}

struct ProtocolSettings: Codable {
    var desyncHTTP: Bool = true
    var desyncHTTPS: Bool = true
    var desyncUDP: Bool = true
    
    // HTTP Settings
    var hostMixedCase: Bool = false
    var domainMixedCase: Bool = false
    var hostRemoveSpaces: Bool = false
    
    // HTTPS Settings
    var splitTLSRecord: Bool = false
    var tlsRecordSplitPosition: Int = 0
    var splitTLSRecordAtSNI: Bool = false
    
    // UDP Settings
    var udpFakeCount: Int = 0
} 