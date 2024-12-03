import SwiftUI

struct ContentView: View {
    @EnvironmentObject var hydrationManager: HydrationManagerImpl
    @EnvironmentObject var weatherService: WeatherService
    @EnvironmentObject var userProfile: UserProfile
    @State private var showingAddSheet = false
    @State private var customAmount: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            // Progress Circle
            ZStack {
                Circle()
                    .stroke(
                        Color.accentColor.opacity(0.2),
                        lineWidth: 20
                    )
                
                Circle()
                    .trim(from: 0, to: CGFloat(min(hydrationManager.currentWaterIntake / hydrationManager.dailyWaterGoal, 1.0)))
                    .stroke(
                        Color.accentColor,
                        style: StrokeStyle(
                            lineWidth: 20,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(), value: hydrationManager.currentWaterIntake)
                
                VStack(spacing: 8) {
                    Text("\(Int(hydrationManager.currentWaterIntake))ml")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("of \(Int(hydrationManager.dailyWaterGoal))ml")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 200, height: 200)
            .padding(.vertical)
            
            // Quick Add Buttons
            VStack(spacing: 16) {
                Text("Quick Add")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 12) {
                    ForEach([100, 250, 500], id: \.self) { amount in
                        Button {
                            hydrationManager.addWater(Double(amount))
                        } label: {
                            VStack {
                                Image(systemName: "drop.fill")
                                    .font(.title2)
                                Text("\(amount)ml")
                                    .font(.callout)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                        }
                        .buttonStyle(.bordered)
                        .tint(.accentColor)
                    }
                }
            }
            .padding(.horizontal)
            
            // Custom Amount
            HStack(spacing: 12) {
                TextField("Custom amount (ml)", text: $customAmount)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 150)
                
                Button {
                    if let amount = Double(customAmount) {
                        hydrationManager.addWater(amount)
                        customAmount = ""
                    }
                } label: {
                    Text("Add")
                        .frame(width: 80)
                }
                .buttonStyle(.borderedProminent)
                .disabled(Double(customAmount) == nil)
            }
            .padding(.horizontal)
            
            // Weather Info
            if let temp = weatherService.temperature {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "thermometer")
                            .foregroundColor(.secondary)
                        Text("\(Int(temp))°C")
                            .font(.headline)
                    }
                    
                    Text(hydrationManager.getTemperatureBasedRecommendation())
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorScheme == .dark ? Color(.windowBackgroundColor) : Color(.textBackgroundColor))
                        .shadow(radius: 2)
                )
            }
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 16) {
                Button(role: .destructive) {
                    hydrationManager.resetProgress()
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.bordered)
                
                Button {
                    exportPDF()
                } label: {
                    Label("Export Report", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom)
        }
        .padding()
        .frame(minWidth: 400, minHeight: 600)
        .background(colorScheme == .dark ? Color(.windowBackgroundColor) : Color(.textBackgroundColor))
    }
    
    func exportPDF() {
        Task {
            guard let pdfData = await PDFGenerator.generateHydrationReport(
                hydrationManager: hydrationManager,
                userProfile: userProfile,
                weatherService: weatherService
            ) else {
                print("Failed to generate PDF")
                return
            }
            
            let savePanel = NSSavePanel()
            savePanel.allowedContentTypes = [.pdf]
            savePanel.nameFieldStringValue = "WaterTracker-Report.pdf"
            
            let response = await savePanel.beginSheetModal(for: NSApp.keyWindow!)
            
            if response == .OK {
                guard let url = savePanel.url else { return }
                do {
                    try pdfData.write(to: url)
                } catch {
                    print("Error saving PDF: \(error.localizedDescription)")
                }
            }
        }
    }
} 