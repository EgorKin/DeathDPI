import Foundation

struct LogEntry: Codable {
    let timestamp: Date
    let message: String
    let level: LogLevel
    
    enum LogLevel: String, Codable {
        case info, warning, error
    }
}

class LogManager {
    static let shared = LogManager()
    private let fileManager = FileManager.default
    
    private init() {}
    
    func log(_ message: String, level: LogEntry.LogLevel = .info) {
        let entry = LogEntry(timestamp: Date(), message: message, level: level)
        NotificationCenter.default.post(name: .newLogEntry, object: entry)
    }
    
    func exportLogs(_ logs: [LogEntry]) -> URL? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        
        let filename = "DeathDPI_\(formatter.string(from: Date())).log"
        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsPath.appendingPathComponent(filename)
        
        let logString = logs.map { "[\($0.timestamp)] [\($0.level.rawValue.uppercased())] \($0.message)" }
            .joined(separator: "\n")
        
        do {
            try logString.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            log("Failed to save logs: \(error.localizedDescription)", level: .error)
            return nil
        }
    }
}

extension Notification.Name {
    static let newLogEntry = Notification.Name("newLogEntry")
} 