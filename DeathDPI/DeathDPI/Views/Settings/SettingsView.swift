import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDNSInput = false
    @State private var tempDNS = ""
    @State private var showingCommandLineInput = false
    
    var body: some View {
        NavigationView {
            List {
                generalSection
                deathDPISection
                aboutSection
            }
            .navigationTitle("Settings")
            .navigationBarItems(
                leading: Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                },
                trailing: Menu {
                    Button("Reset", action: resetSettings)
                } label: {
                    Image(systemName: "ellipsis")
                }
            )
        }
    }
    
    private var generalSection: some View {
        Section(header: Text("General")) {
            // Theme Picker
            Picker("Theme", selection: $appState.settings.theme) {
                Text("System").tag(Settings.Theme.system)
                Text("Light").tag(Settings.Theme.light)
                Text("Dark").tag(Settings.Theme.dark)
            }
            
            // Mode Picker
            Picker("Mode", selection: $appState.settings.mode) {
                Text("VPN").tag(Settings.ConnectionMode.vpn)
                Text("Proxy").tag(Settings.ConnectionMode.proxy)
            }
            
            // DNS Button
            Button(action: { showingDNSInput = true }) {
                HStack {
                    Text("DNS")
                    Spacer()
                    Text(appState.settings.dns)
                        .foregroundColor(.gray)
                }
            }
            
            // IPv6 Toggle
            Toggle("IPv6", isOn: $appState.settings.ipv6Enabled)
        }
        .alert("DNS Settings", isPresented: $showingDNSInput) {
            TextField("DNS Address", text: $tempDNS)
            Button("Cancel", role: .cancel) { }
            Button("OK") {
                if !tempDNS.isEmpty {
                    appState.settings.dns = tempDNS
                }
            }
        }
    }
    
    private var deathDPISection: some View {
        Section(header: Text("DeathDPI")) {
            Toggle("Use Command Line Settings", isOn: $appState.settings.useCommandLine)
            
            NavigationLink(destination: UIEditorView()) {
                Text("UI Editor")
            }
            
            Button(action: { showingCommandLineInput = true }) {
                HStack {
                    Text("Command Line Editor")
                    Spacer()
                    Text(appState.settings.commandLineArgs.isEmpty ? "Not Set" : "Set")
                        .foregroundColor(.gray)
                }
            }
            .disabled(!appState.settings.useCommandLine)
        }
        .sheet(isPresented: $showingCommandLineInput) {
            CommandLineEditorView()
        }
    }
    
    private var aboutSection: some View {
        Section(header: Text("About")) {
            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
            }
            
            Link(destination: URL(string: "https://github.com/yourusername/DeathDPI")!) {
                HStack {
                    Image(systemName: "link")
                    Text("Source Code")
                }
            }
        }
    }
    
    private func resetSettings() {
        appState.settings = Settings()
    }
} 