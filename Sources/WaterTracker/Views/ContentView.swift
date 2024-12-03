import SwiftUI

struct ContentView: View {
    @EnvironmentObject var hydrationManager: HydrationManagerImpl
    @EnvironmentObject var userProfile: UserProfile
    @State private var customAmount: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 32) {
                    // Progress Circle
                    ZStack {
                        Circle()
                            .stroke(
                                Color.accentColor.opacity(0.1),
                                lineWidth: 24
                            )
                            .background(
                                Circle()
                                    .fill(colorScheme == .dark ? 
                                        Color(.windowBackgroundColor).opacity(0.5) : 
                                        Color(.textBackgroundColor).opacity(0.5))
                            )
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(min(hydrationManager.currentWaterIntake / hydrationManager.dailyWaterGoal, 1.0)))
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.accentColor, .accentColor.opacity(0.7)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                style: StrokeStyle(
                                    lineWidth: 24,
                                    lineCap: .round
                                )
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.spring(response: 0.6), value: hydrationManager.currentWaterIntake)
                        
                        VStack(spacing: 8) {
                            Text("\(Int(hydrationManager.currentWaterIntake))ml")
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text("of \(Int(hydrationManager.dailyWaterGoal))ml")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: min(geometry.size.width * 0.6, 200), height: min(geometry.size.width * 0.6, 200))
                    .padding(.vertical)
                    
                    // Quick Add Buttons
                    VStack(spacing: 20) {
                        Text("Quick Add")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach([100, 250, 500], id: \.self) { amount in
                                Button {
                                    hydrationManager.addWater(Double(amount))
                                } label: {
                                    VStack(spacing: 8) {
                                        Image(systemName: "drop.fill")
                                            .font(.title2)
                                            .foregroundColor(.accentColor)
                                        Text("\(amount)ml")
                                            .font(.callout)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(colorScheme == .dark ? 
                                                Color(.windowBackgroundColor) : 
                                                Color(.textBackgroundColor))
                                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Custom Amount
                    HStack(spacing: 12) {
                        TextField("Custom amount (ml)", text: $customAmount)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
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
                    
                    // Temperature Recommendation
                    if let temp = userProfile.currentTemperature {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "thermometer")
                                    .foregroundColor(.secondary)
                                Text("\(Int(temp))°C")
                                    .font(.headline)
                            }
                            
                            Text(userProfile.getTemperatureBasedRecommendation())
                                .font(.callout)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(colorScheme == .dark ? 
                                    Color(.windowBackgroundColor) : 
                                    Color(.textBackgroundColor))
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 20)
                    
                    // Action Buttons
                    HStack(spacing: 16) {
                        Button(role: .destructive) {
                            hydrationManager.resetProgress()
                        } label: {
                            Label("Reset", systemImage: "arrow.counterclockwise")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                        }
                        .buttonStyle(.bordered)
                        
                        Button {
                            exportPDF()
                        } label: {
                            Label("Export Report", systemImage: "square.and.arrow.up")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.bottom)
                }
                .padding()
            }
        }
        .background(colorScheme == .dark ? Color(.windowBackgroundColor) : Color(.textBackgroundColor))
    }
    
    func exportPDF() {
        Task {
            guard let pdfData = await PDFGenerator.generateHydrationReport(
                hydrationManager: hydrationManager,
                userProfile: userProfile
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