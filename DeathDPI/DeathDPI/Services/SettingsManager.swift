import Foundation

class SettingsManager {
    static let shared = SettingsManager()
    private let defaults = UserDefaults.standard
    private let settingsKey = "com.deathdpi.settings"
    
    private init() {}
    
    func saveSettings(_ settings: Settings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            defaults.set(encoded, forKey: settingsKey)
        }
    }
    
    func loadSettings() -> Settings {
        if let data = defaults.data(forKey: settingsKey),
           let settings = try? JSONDecoder().decode(Settings.self, from: data) {
            return settings
        }
        return Settings()
    }
    
    func resetSettings() {
        defaults.removeObject(forKey: settingsKey)
    }
} 