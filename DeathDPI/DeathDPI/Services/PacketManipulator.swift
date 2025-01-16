import Foundation
import Network

class PacketManipulator {
    static let shared = PacketManipulator()
    
    private init() {}
    
    func manipulateHTTPPacket(_ data: Data, settings: ProtocolSettings) -> Data {
        var packet = data
        
        if settings.hostMixedCase {
            packet = applyMixedCase(to: packet, field: "Host:")
        }
        
        if settings.domainMixedCase {
            packet = applyMixedCase(to: packet, field: "domain=")
        }
        
        if settings.hostRemoveSpaces {
            packet = removeSpaces(from: packet, field: "Host:")
        }
        
        return packet
    }
    
    func manipulateHTTPSPacket(_ data: Data, settings: ProtocolSettings) -> [Data] {
        var packets = [data]
        
        if settings.splitTLSRecord {
            packets = splitTLSRecord(data,
                                   position: settings.tlsRecordSplitPosition,
                                   splitAtSNI: settings.splitTLSRecordAtSNI)
        }
        
        return packets
    }
    
    private func applyMixedCase(to data: Data, field: String) -> Data {
        var packet = [UInt8](data)
        let pattern = [UInt8](field.utf8)
        
        // Find field in packet
        for i in 0...(packet.count - pattern.count) {
            if packet[i..<(i + pattern.count)].elementsEqual(pattern) {
                // Found the field, now mix the case of the value
                var j = i + pattern.count
                var toggle = true
                
                while j < packet.count && packet[j] != 13 { // Until CR
                    if packet[j].isASCIILetter {
                        packet[j] = toggle ? packet[j].uppercased : packet[j].lowercased
                        toggle.toggle()
                    }
                    j += 1
                }
                break
            }
        }
        
        return Data(packet)
    }
    
    private func removeSpaces(from data: Data, field: String) -> Data {
        var packet = [UInt8](data)
        let pattern = [UInt8](field.utf8)
        
        // Find field in packet
        for i in 0...(packet.count - pattern.count) {
            if packet[i..<(i + pattern.count)].elementsEqual(pattern) {
                // Found the field, now remove spaces from the value
                var j = i + pattern.count
                var writeIndex = j
                
                while j < packet.count && packet[j] != 13 { // Until CR
                    if packet[j] != 32 { // Not a space
                        packet[writeIndex] = packet[j]
                        writeIndex += 1
                    }
                    j += 1
                }
                
                // Move remaining packet data
                packet[writeIndex..<j].removeAll()
                break
            }
        }
        
        return Data(packet)
    }
    
    private func splitTLSRecord(_ data: Data, position: Int, splitAtSNI: Bool) -> [Data] {
        var packets: [Data] = []
        var packet = [UInt8](data)
        
        if splitAtSNI {
            // Find SNI extension in TLS handshake
            if let sniPosition = findSNIPosition(in: packet) {
                let firstPart = Data(packet[0..<sniPosition])
                let secondPart = Data(packet[sniPosition...])
                packets = [firstPart, secondPart]
            }
        } else {
            // Split at specified position
            let splitPos = min(position, packet.count)
            let firstPart = Data(packet[0..<splitPos])
            let secondPart = Data(packet[splitPos...])
            packets = [firstPart, secondPart]
        }
        
        return packets
    }
    
    private func findSNIPosition(in packet: [UInt8]) -> Int? {
        // TLS SNI extension ID is 0x0000
        let sniPattern: [UInt8] = [0x00, 0x00]
        
        for i in 0...(packet.count - sniPattern.count) {
            if packet[i..<(i + sniPattern.count)].elementsEqual(sniPattern) {
                return i
            }
        }
        
        return nil
    }
} 