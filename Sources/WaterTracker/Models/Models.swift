import Foundation
import SwiftUI

// MARK: - Models

struct HydrationEntry: Codable, Identifiable {
    let id: UUID
    let amount: Double
    let timestamp: Date
    
    init(id: UUID = UUID(), amount: Double, timestamp: Date = Date()) {
        self.id = id
        self.amount = amount
        self.timestamp = timestamp
    }
}

struct DailyHydrationSummary: Identifiable {
    let id = UUID()
    let date: Date
    let totalAmount: Double
    let percentage: Double
}

// MARK: - View Models

@MainActor
class HydrationManagerImpl: ObservableObject {
    @Published var currentWaterIntake: Double = 0
    @Published var dailyWaterGoal: Double = 2000 // Default goal in milliliters
    @Published private(set) var entries: [HydrationEntry] = []
    @Published var temperature: Double?
    
    private let calendar = Calendar.current
    private let defaults = UserDefaults.standard
    private let entriesKey = "hydrationEntries"
    private let currentIntakeKey = "currentWaterIntake"
    private let dailyGoalKey = "dailyWaterGoal"
    
    init() {
        loadData()
    }
    
    func addWater(_ amount: Double) {
        let entry = HydrationEntry(amount: amount)
        entries.append(entry)
        currentWaterIntake += amount
        saveData()
    }
    
    func resetProgress() {
        currentWaterIntake = 0
        entries.removeAll()
        saveData()
    }
    
    func getTemperatureBasedRecommendation() -> String {
        if let temp = temperature {
            let extraWater = max(0, (temp - 20) * 50) // 50ml extra for each degree above 20°C
            let recommendedTotal = dailyWaterGoal + extraWater
            return String(format: "Based on the current temperature of %.1f°C, you should aim to drink %.0f ml of water today.", temp, recommendedTotal)
        } else {
            return "Loading temperature data..."
        }
    }
    
    func dailyAverages(for dateComponents: DateComponents) -> [(Date, Double)] {
        let endDate = Date()
        guard let startDate = calendar.date(byAdding: dateComponents, to: endDate) else {
            return []
        }
        
        var result: [(Date, Double)] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            let dailyTotal = entries
                .filter { calendar.isDate($0.timestamp, inSameDayAs: currentDate) }
                .reduce(0) { $0 + $1.amount }
            
            let percentage = (dailyTotal / dailyWaterGoal) * 100
            result.append((currentDate, percentage))
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return result
    }
    
    func averageHydration(for dateComponents: DateComponents) -> Double {
        let averages = dailyAverages(for: dateComponents)
        guard !averages.isEmpty else { return 0 }
        
        let total = averages.reduce(0.0) { $0 + $1.1 }
        return total / Double(averages.count)
    }
    
    private func loadData() {
        if let data = defaults.data(forKey: entriesKey),
           let decodedEntries = try? JSONDecoder().decode([HydrationEntry].self, from: data) {
            entries = decodedEntries
        }
        
        currentWaterIntake = defaults.double(forKey: currentIntakeKey)
        
        let savedGoal = defaults.double(forKey: dailyGoalKey)
        if savedGoal > 0 {
            dailyWaterGoal = savedGoal
        }
    }
    
    private func saveData() {
        if let encoded = try? JSONEncoder().encode(entries) {
            defaults.set(encoded, forKey: entriesKey)
        }
        
        defaults.set(currentWaterIntake, forKey: currentIntakeKey)
        defaults.set(dailyWaterGoal, forKey: dailyGoalKey)
    }
} 