import SwiftUI
import Combine
import CoreLocation

enum TimePeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    var dateComponents: DateComponents {
        switch self {
        case .week:
            return DateComponents(day: -7)
        case .month:
            return DateComponents(month: -1)
        case .year:
            return DateComponents(year: -1)
        }
    }
}

struct HydrationTrendsView: View {
    @ObservedObject var hydrationManager: HydrationManagerImpl
    @State private var selectedPeriod: TimePeriod = .week
    @State private var selectedDate: Date?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 40))
                        .foregroundColor(.accentColor)
                    
                    Text("Hydration Trends")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.vertical)
                
                // Period Selection
                Picker("Time Period", selection: $selectedPeriod) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Statistics Card
                let average = hydrationManager.averageHydration(for: selectedPeriod.dateComponents)
                GroupBox {
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Average Hydration")
                                    .font(.headline)
                                Text("For the selected period")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text("\(Int(average))%")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.accentColor)
                        }
                        
                        ProgressView(value: average, total: 100)
                            .tint(.accentColor)
                    }
                    .padding()
                } label: {
                    Label("Statistics", systemImage: "percent")
                }
                .padding(.horizontal)
                
                // Chart
                GroupBox {
                    let data = hydrationManager.dailyAverages(for: selectedPeriod.dateComponents)
                    if !data.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Daily Progress")
                                .font(.headline)
                            
                            Chart {
                                ForEach(data, id: \.0) { date, percentage in
                                    BarMark(
                                        x: .value("Date", date),
                                        y: .value("Percentage", percentage)
                                    )
                                    .foregroundStyle(Color.accentColor.gradient)
                                }
                            }
                            .frame(height: 200)
                        }
                        .padding()
                    } else {
                        Text("No data available for selected period")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                } label: {
                    Label("Progress Chart", systemImage: "chart.bar.fill")
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .background(colorScheme == .dark ? Color(.windowBackgroundColor) : Color(.textBackgroundColor))
    }
}

struct Chart: View {
    let content: () -> any View
    
    init(@ViewBuilder content: @escaping () -> any View) {
        self.content = content
    }
    
    var body: some View {
        AnyView(content())
    }
}

struct BarMark: View {
    let x: PlottableValue
    let y: PlottableValue
    private var foregroundColor: Color = .accentColor
    
    init(x: PlottableValue, y: PlottableValue) {
        self.x = x
        self.y = y
    }
    
    func foregroundStyle(_ gradient: LinearGradient) -> BarMark {
        var copy = self
        copy.foregroundColor = .accentColor
        return copy
    }
    
    var body: some View {
        Rectangle()
            .fill(foregroundColor.gradient)
            .frame(width: 20, height: CGFloat(y.value as? Double ?? 0) * 2)
    }
}

struct PlottableValue {
    let label: String
    let value: Any
    
    static func value(_ label: String, _ value: Any) -> PlottableValue {
        PlottableValue(label: label, value: value)
    }
} 