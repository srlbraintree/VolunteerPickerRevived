import Foundation

class AppData: ObservableObject {
    @Published var names: [String] = UserDefaults.standard.stringArray(forKey: "SavedNames") ?? [] {
        didSet {
            saveNames()
        }
    }

    func saveNames() {
        UserDefaults.standard.set(names, forKey: "SavedNames")
    }
}
