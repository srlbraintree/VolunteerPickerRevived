import SwiftUI

struct NameEntryWindow: View {
    @EnvironmentObject var appData: AppData
    @State private var nameInput: String = UserDefaults.standard.string(forKey: "LastNameInput") ?? ""

    var body: some View {
        VStack {
            Text("Enter Names")
                .font(.title)
                .padding()

            TextEditor(text: $nameInput)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(8)
                .padding()

            Button("Put the Names in the Boxes") {
                submitNames()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .frame(minWidth: 600, minHeight: 400)
    }

    func submitNames() {
        let separatedNames = nameInput
            .split(whereSeparator: \.isNewline)
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        appData.names = separatedNames
        UserDefaults.standard.set(nameInput, forKey: "LastNameInput")
    }
}
