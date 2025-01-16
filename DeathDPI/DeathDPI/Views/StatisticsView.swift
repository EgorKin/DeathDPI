import SwiftUI

struct StatisticsView: View {
    @ObservedObject private var stats = NetworkStatistics.shared
    
    var body: some View {
        List {
            Section(header: Text("Traffic")) {
                StatRow(title: "Bytes In", value: formatBytes(stats.bytesIn))
                StatRow(title: "Bytes Out", value: formatBytes(stats.bytesOut))
            }
            
            Section(header: Text("Connections")) {
                StatRow(title: "Active", value: "\(stats.activeConnections)")
                StatRow(title: "Total", value: "\(stats.totalConnections)")
            }
            
            Section(header: Text("DPI Bypass")) {
                StatRow(title: "Packets Manipulated", value: "\(stats.packetsManipulated)")
            }
        }
        .navigationTitle("Statistics")
    }
    
    private func formatBytes(_ bytes: UInt64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .binary
        return formatter.string(fromByteCount: Int64(bytes))
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
} 