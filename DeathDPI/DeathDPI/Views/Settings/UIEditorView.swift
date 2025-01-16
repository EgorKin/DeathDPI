import SwiftUI

struct UIEditorView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Form {
            proxySection
            desyncSection
            protocolsSection
            httpSection
            httpsSection
            udpSection
        }
        .navigationTitle("UI Editor")
    }
    
    private var proxySection: some View {
        Section(header: Text("Proxy")) {
            TextField("Listen Address", text: $appState.settings.proxySettings.listenAddress)
            
            Stepper("Port: \(appState.settings.proxySettings.port)",
                   value: $appState.settings.proxySettings.port,
                   in: 1...65535)
            
            Stepper("Max Connections: \(appState.settings.proxySettings.maxConnections)",
                   value: $appState.settings.proxySettings.maxConnections,
                   in: 1...10000)
            
            Stepper("Buffer Size: \(appState.settings.proxySettings.bufferSize)",
                   value: $appState.settings.proxySettings.bufferSize,
                   in: 1024...65536,
                   step: 1024)
            
            Toggle("No Domain", isOn: $appState.settings.proxySettings.noDomain)
            Toggle("TCP Fast Open", isOn: $appState.settings.proxySettings.tcpFastOpen)
        }
    }
    
    private var desyncSection: some View {
        Section(header: Text("Desync")) {
            Picker("Hosts", selection: $appState.settings.desyncSettings.hostMode) {
                Text("Disable").tag(DesyncSettings.HostMode.disable)
                Text("Blacklist").tag(DesyncSettings.HostMode.blacklist)
                Text("Whitelist").tag(DesyncSettings.HostMode.whitelist)
            }
            
            Stepper("Default TTL: \(appState.settings.desyncSettings.defaultTTL)",
                   value: $appState.settings.desyncSettings.defaultTTL,
                   in: 0...255)
            
            Picker("Desync Method", selection: $appState.settings.desyncSettings.desyncMethod) {
                Text("None").tag(DesyncSettings.DesyncMethod.none)
                Text("Split").tag(DesyncSettings.DesyncMethod.split)
                Text("Disorder").tag(DesyncSettings.DesyncMethod.disorder)
                Text("Fake").tag(DesyncSettings.DesyncMethod.fake)
                Text("Out-of-band").tag(DesyncSettings.DesyncMethod.outOfBand)
                Text("Disordered out-of-band").tag(DesyncSettings.DesyncMethod.disorderedOutOfBand)
            }
            
            Stepper("Split Position: \(appState.settings.desyncSettings.splitPosition)",
                   value: $appState.settings.desyncSettings.splitPosition,
                   in: 1...100)
            
            Toggle("Split at Host", isOn: $appState.settings.desyncSettings.splitAtHost)
            Toggle("Drop SACK", isOn: $appState.settings.desyncSettings.dropSACK)
        }
    }
    
    private var protocolsSection: some View {
        Section(header: Text("Protocols"), footer: Text("Uncheck all to desync all traffic")) {
            Toggle("Desync HTTP", isOn: $appState.settings.protocolSettings.desyncHTTP)
            Toggle("Desync HTTPS", isOn: $appState.settings.protocolSettings.desyncHTTPS)
            Toggle("Desync UDP", isOn: $appState.settings.protocolSettings.desyncUDP)
        }
    }
    
    private var httpSection: some View {
        Section(header: Text("HTTP")) {
            Toggle("Host Mixed Case", isOn: $appState.settings.protocolSettings.hostMixedCase)
            Toggle("Domain Mixed Case", isOn: $appState.settings.protocolSettings.domainMixedCase)
            Toggle("Host Remove Spaces", isOn: $appState.settings.protocolSettings.hostRemoveSpaces)
        }
    }
    
    private var httpsSection: some View {
        Section(header: Text("HTTPS")) {
            Toggle("Split TLS Record", isOn: $appState.settings.protocolSettings.splitTLSRecord)
            
            if appState.settings.protocolSettings.splitTLSRecord {
                Stepper("Split Position: \(appState.settings.protocolSettings.tlsRecordSplitPosition)",
                       value: $appState.settings.protocolSettings.tlsRecordSplitPosition,
                       in: 0...100)
                
                Toggle("Split at SNI", isOn: $appState.settings.protocolSettings.splitTLSRecordAtSNI)
            }
        }
    }
    
    private var udpSection: some View {
        Section(header: Text("UDP")) {
            if appState.settings.protocolSettings.desyncUDP {
                Stepper("Fake Count: \(appState.settings.protocolSettings.udpFakeCount)",
                       value: $appState.settings.protocolSettings.udpFakeCount,
                       in: 0...100)
            }
        }
    }
} 