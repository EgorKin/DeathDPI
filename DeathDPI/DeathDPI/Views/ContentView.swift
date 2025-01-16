import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingMenu = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("DeathDPI")
                        .font(.title)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                    }
                    
                    Menu {
                        Button("Save Logs") {
                            if let url = appState.saveLogs() {
                                // Handle successful log save
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
                .padding()
                
                Spacer()
                
                // Connection Status
                VStack(spacing: 20) {
                    Button(action: {
                        if appState.isConnected {
                            appState.disconnect()
                        } else {
                            appState.connect()
                        }
                    }) {
                        Text(appState.isConnected ? "Disconnect" : "Connect")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(appState.isConnected ? Color.red : Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Text(appState.isConnected ? "Connected" : "Disconnected")
                        .foregroundColor(appState.isConnected ? .green : .red)
                    
                    Text(appState.currentIP)
                        .font(.caption)
                    
                    if appState.isConnected {
                        NavigationLink(destination: StatisticsView()) {
                            Text("View Statistics")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Spacer()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
} 