import Foundation

enum ActivityLevel: String, CaseIterable {
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    case extremelyActive = "Extremely Active"
    
    var hydrationMultiplier: Double {
        switch self {
        case .sedentary: return 1.0
        case .lightlyActive: return 1.2
        case .moderatelyActive: return 1.4
        case .veryActive: return 1.6
        case .extremelyActive: return 1.8
        }
    }
}

enum ClimateZone: String, CaseIterable {
    case temperate = "Temperate"
    case tropical = "Tropical"
    case arid = "Arid"
    case mediterranean = "Mediterranean"
    case polar = "Polar"
    
    var hydrationMultiplier: Double {
        switch self {
        case .temperate: return 1.0
        case .tropical: return 1.3
        case .arid: return 1.4
        case .mediterranean: return 1.2
        case .polar: return 0.9
        }
    }
    
    var baseTemperature: Double {
        switch self {
        case .temperate: return 20.0
        case .tropical: return 30.0
        case .arid: return 35.0
        case .mediterranean: return 25.0
        case .polar: return 10.0
        }
    }
}

enum HealthCondition: String, CaseIterable, Hashable {
    case diabetes = "Diabetes"
    case hypertension = "Hypertension"
    case kidneyDisease = "Kidney Disease"
    case heartCondition = "Heart Condition"
    case pregnancy = "Pregnancy"
    
    var name: String { rawValue }
    
    var hydrationAdjustment: Double {
        switch self {
        case .diabetes: return 1.2
        case .hypertension: return 1.1
        case .kidneyDisease: return 0.9
        case .heartCondition: return 1.1
        case .pregnancy: return 1.3
        }
    }
}

@MainActor
class UserProfile: ObservableObject {
    @Published var age: Int = 30
    @Published var weight: Double = 70.0
    @Published var activityLevel: ActivityLevel = .moderatelyActive
    @Published var climateZone: ClimateZone = .temperate
    @Published var healthConditions: Set<HealthCondition> = []
    @Published var currentTemperature: Double?
    
    private let apiKey = "625818d31eec539e08d410b42609bf22"
    
    func calculateDailyWaterGoal() -> Double {
        // Base calculation: 30ml per kg of body weight
        var baseGoal = weight * 30
        
        // Adjust for activity level
        baseGoal *= activityLevel.hydrationMultiplier
        
        // Adjust for climate
        baseGoal *= climateZone.hydrationMultiplier
        
        // Adjust for health conditions
        for condition in healthConditions {
            baseGoal *= condition.hydrationAdjustment
        }
        
        // Age adjustment: reduce by 10% for every decade over 60
        if age > 60 {
            let decadesOver60 = Double(age - 60) / 10.0
            baseGoal *= pow(0.9, decadesOver60)
        }
        
        // Temperature adjustment
        if let temp = currentTemperature {
            let baseTemp = climateZone.baseTemperature
            if temp > baseTemp {
                // Add 50ml for each degree above base temperature
                baseGoal += (temp - baseTemp) * 50
            }
        }
        
        return baseGoal
    }
    
    func getTemperatureBasedRecommendation() -> String {
        guard let temp = currentTemperature else {
            return "Set your climate zone for personalized recommendations."
        }
        
        let baseTemp = climateZone.baseTemperature
        let difference = temp - baseTemp
        
        if difference > 10 {
            return "High temperature alert! Increase your water intake significantly."
        } else if difference > 5 {
            return "Temperature is above normal for your climate zone. Consider drinking more water."
        } else if difference < -5 {
            return "Temperature is below normal for your climate zone. Maintain regular hydration."
        } else {
            return "Temperature is normal for your climate zone. Follow your regular hydration goal."
        }
    }
    
    func updateTemperature(_ temperature: Double) {
        currentTemperature = temperature
        objectWillChange.send()
    }
} 