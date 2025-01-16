import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                LogManager.shared.log("Failed to request notification authorization: \(error.localizedDescription)", level: .error)
            }
        }
    }
    
    func notifyConnectionStatus(_ connected: Bool) {
        let content = UNMutableNotificationContent()
        content.title = "DeathDPI Connection Status"
        content.body = connected ? "Successfully connected" : "Connection lost"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
    
    func notifyError(_ error: DPIError) {
        let content = UNMutableNotificationContent()
        content.title = "DeathDPI Error"
        content.body = error.localizedDescription
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
} 