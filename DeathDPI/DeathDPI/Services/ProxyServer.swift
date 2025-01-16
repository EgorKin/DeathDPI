import Foundation
import Network

class ProxyServer {
    private var listener: NWListener?
    private var connections: [NWConnection] = []
    private let packetManipulator = PacketManipulator.shared
    private let queue = DispatchQueue(label: "com.deathdpi.proxy")
    private var settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    func start() throws {
        let parameters = NWParameters.tcp
        
        // Configure TCP options
        if settings.proxySettings.tcpFastOpen {
            parameters.enableFastOpen = true
        }
        
        // Create the listener
        listener = try NWListener(using: parameters)
        
        // Set up the listener handler
        listener?.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                LogManager.shared.log("Proxy server is running", level: .info)
            case .failed(let error):
                LogManager.shared.log("Proxy server failed: \(error)", level: .error)
                self?.stop()
            default:
                break
            }
        }
        
        // Handle new connections
        listener?.newConnectionHandler = { [weak self] connection in
            self?.handleNewConnection(connection)
        }
        
        // Start listening
        listener?.start(queue: queue)
    }
    
    private func handleNewConnection(_ connection: NWConnection) {
        connections.append(connection)
        
        connection.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                self?.receiveData(on: connection)
            case .failed(let error):
                LogManager.shared.log("Connection failed: \(error)", level: .error)
                self?.removeConnection(connection)
            case .cancelled:
                self?.removeConnection(connection)
            default:
                break
            }
        }
        
        connection.start(queue: queue)
    }
    
    private func receiveData(on connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: settings.proxySettings.bufferSize) { [weak self] content, _, isComplete, error in
            if let error = error {
                LogManager.shared.log("Receive error: \(error)", level: .error)
                self?.removeConnection(connection)
                return
            }
            
            if let data = content {
                self?.handleReceivedData(data, on: connection)
            }
            
            if !isComplete {
                self?.receiveData(on: connection)
            }
        }
    }
    
    private func handleReceivedData(_ data: Data, on connection: NWConnection) {
        var manipulatedData = data
        
        // Apply DPI bypass techniques based on settings
        if settings.protocolSettings.desyncHTTP {
            manipulatedData = packetManipulator.manipulateHTTPPacket(data, settings: settings.protocolSettings)
        }
        
        if settings.protocolSettings.desyncHTTPS {
            let packets = packetManipulator.manipulateHTTPSPacket(data, settings: settings.protocolSettings)
            for packet in packets {
                sendData(packet, on: connection)
            }
            return
        }
        
        sendData(manipulatedData, on: connection)
    }
    
    private func sendData(_ data: Data, on connection: NWConnection) {
        connection.send(content: data, completion: .contentProcessed { [weak self] error in
            if let error = error {
                LogManager.shared.log("Send error: \(error)", level: .error)
                self?.removeConnection(connection)
            }
        })
    }
    
    private func removeConnection(_ connection: NWConnection) {
        connection.cancel()
        if let index = connections.firstIndex(where: { $0 === connection }) {
            connections.remove(at: index)
        }
    }
    
    func stop() {
        listener?.cancel()
        connections.forEach { $0.cancel() }
        connections.removeAll()
    }
} 