import SwiftUI

struct MainWindow: View {
    @EnvironmentObject var appData: AppData
    @State private var boxColors: [String: Color] = [:]
    @State private var selectedName: String?

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "#121212"), Color(hex: "#1C1C1C")]),
                startPoint: .top, endPoint: .bottom
            ).ignoresSafeArea()

            VStack {
                GeometryReader { geometry in
                    if appData.names.isEmpty {
                        Text("Waiting for Names")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        let (columns, rows) = calculateGrid(for: appData.names.count, in: geometry.size)
                        let boxSize = calculateBoxSize(columns: columns, rows: rows, in: geometry.size)

                        ZStack {
                            ForEach(Array(appData.names.enumerated()), id: \.offset) { index, fullName in
                                let (firstName, lastInitial) = splitName(fullName)
                                let (xOffset, yOffset) = calculatePosition(
                                    index: index, columns: columns, boxSize: boxSize, windowSize: geometry.size
                                )

                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 2)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(boxColors[fullName] ?? randomDynatraceColor())
                                        )
                                        .frame(width: boxSize, height: boxSize)
                                        .position(x: xOffset, y: yOffset)

                                    VStack {
                                        Text(firstName)
                                            .foregroundColor(.white)
                                            .font(.system(size: boxSize * 0.25, weight: .bold))
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(1)

                                        Text(lastInitial)
                                            .foregroundColor(.white)
                                            .font(.system(size: boxSize * 0.12, weight: .medium))
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(1)
                                    }
                                    .frame(width: boxSize - 20, height: boxSize - 40)
                                    .multilineTextAlignment(.center)
                                    .position(x: xOffset, y: yOffset)
                                }
                            }
                        }
                    }
                }

                HStack(spacing: 20) {
                    Button("Choose") {
                        startAnimation()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(appData.names.isEmpty)

                    Button("Reset") {
                        resetBoxes()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color.black.opacity(0.6))

                if let selectedName = selectedName {
                    Text(selectedName)
                        .foregroundColor(.white)
                        .font(.system(size: 40, weight: .bold))
                        .padding(.top, 20)
                }
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .onAppear {
            assignRandomColors()
        }
    }
}

// MARK: - Helper Functions
extension MainWindow {
    func assignRandomColors() {
        for name in appData.names where boxColors[name] == nil {
            boxColors[name] = randomDynatraceColor()
        }
    }

    func startAnimation() {
        // Placeholder for animation logic
        selectedName = appData.names.randomElement()
    }

    func resetBoxes() {
        selectedName = nil
        assignRandomColors()
    }

    func calculateGrid(for count: Int, in size: CGSize) -> (columns: Int, rows: Int) {
        let idealSize: CGFloat = 120
        let columns = max(1, Int(size.width / idealSize))
        let rows = max(1, Int(ceil(Double(count) / Double(columns))))
        return (columns, rows)
    }

    func calculateBoxSize(columns: Int, rows: Int, in size: CGSize) -> CGFloat {
        let padding: CGFloat = 10
        let availableWidth = size.width - CGFloat(columns + 1) * padding
        let availableHeight = size.height * 0.75 - CGFloat(rows + 1) * padding
        return min(availableWidth / CGFloat(columns), availableHeight / CGFloat(rows))
    }

    func calculatePosition(index: Int, columns: Int, boxSize: CGFloat, windowSize: CGSize) -> (x: CGFloat, y: CGFloat) {
        let padding: CGFloat = 10
        let col = index % columns
        let row = index / columns
        let x = CGFloat(col) * (boxSize + padding) + boxSize / 2 + padding
        let y = CGFloat(row) * (boxSize + padding) + boxSize / 2 + padding
        return (x, y)
    }

    func splitName(_ fullName: String) -> (String, String) {
        let components = fullName.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        let firstName = components.first.map { String($0) } ?? ""
        let lastInitial = components.count > 1 ? String(components[1].prefix(1)) : ""
        return (firstName, lastInitial)
    }

    func randomDynatraceColor() -> Color {
        let colors = [
            Color(hex: "#1496FF"),
            Color(hex: "#6F2DA8"),
            Color(hex: "#73BE28"),
            Color(hex: "#B4DC00")
        ]
        return colors.randomElement()!
    }
}

// MARK: - Hex Color Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex.hasPrefix("#") ? String(hex.dropFirst()) : hex)

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue & 0xFF0000) >> 16) / 255
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255
        let blue = Double(rgbValue & 0x0000FF) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
    }
}
