import SwiftUI

struct CommandLineEditorView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var tempArgs: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $tempArgs)
                    .font(.system(.body, design: .monospaced))
                    .padding()
                    .onAppear {
                        tempArgs = appState.settings.commandLineArgs
                    }
            }
            .navigationTitle("Command Line Editor")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    appState.settings.commandLineArgs = tempArgs
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
} 