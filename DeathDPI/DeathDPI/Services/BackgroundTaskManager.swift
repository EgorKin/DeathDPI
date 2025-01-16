import Foundation
import BackgroundTasks

class BackgroundTaskManager {
    static let shared = BackgroundTaskManager()
    
    private init() {
        registerBackgroundTasks()
    }
    
    private func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.deathdpi.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.deathdpi.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            LogManager.shared.log("Failed to schedule app refresh: \(error.localizedDescription)", level: .error)
        }
    }
    
    private func handleAppRefresh(task: BGAppRefreshTask) {
        // Add task assertion
        task.expirationHandler = {
            // Clean up if needed
        }
        
        // Refresh connection if needed
        if NetworkStatistics.shared.activeConnections > 0 {
            _ = DPIManager.shared.startConnection(with: AppState().settings)
        }
        
        task.setTaskCompleted(success: true)
        
        // Schedule the next refresh
        scheduleAppRefresh()
    }
} 