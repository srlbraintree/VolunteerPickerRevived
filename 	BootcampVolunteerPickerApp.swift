import SwiftUI

@main
struct BootcampVolunteerPickerApp: App {
    @StateObject private var appData = AppData()

    var body: some Scene {
        WindowGroup("Name Entry") {
            NameEntryWindow()
                .environmentObject(appData)
                .onAppear {
                    openMainWindow(appData: appData)
                }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

func openMainWindow(appData: AppData) {
    if let window = NSApplication.shared.windows.first(where: { $0.title == "Main Window" }) {
        window.makeKeyAndOrderFront(nil)
    } else {
        let newWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        newWindow.title = "Main Window"
        newWindow.contentView = NSHostingView(
            rootView: MainWindow().environmentObject(appData)
        )
        newWindow.makeKeyAndOrderFront(nil)
    }
}
