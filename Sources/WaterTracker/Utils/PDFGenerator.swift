import Foundation
import AppKit
import PDFKit
import QuartzCore

@MainActor
struct PDFGenerator {
    static func generateHydrationReport(
        hydrationManager: HydrationManagerImpl,
        userProfile: UserProfile,
        weatherService: WeatherService
    ) async -> Data? {
        // Create PDF document
        let pdfData = NSMutableData()
        var mediaBox = CGRect(origin: .zero, size: CGSize(width: 612, height: 792))
        
        // Create PDF context
        guard let context = CGContext(consumer: CGDataConsumer(data: pdfData)!, mediaBox: &mediaBox, nil) else {
            return nil
        }
        
        let auxiliaryInfo: CFDictionary? = nil
        context.beginPDFPage(auxiliaryInfo)
        
        // Save graphics state
        context.saveGState()
        
        // Flip coordinates for macOS drawing
        context.translateBy(x: 0, y: 792) // Page height
        context.scaleBy(x: 1.0, y: -1.0)
        
        // Draw content
        let titleFont = NSFont.boldSystemFont(ofSize: 24)
        let headerFont = NSFont.boldSystemFont(ofSize: 16)
        let bodyFont = NSFont.systemFont(ofSize: 12)
        
        // Title attributes
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: NSColor.black
        ]
        
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: headerFont,
            .foregroundColor: NSColor.black
        ]
        
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: NSColor.black
        ]
        
        // Draw title
        "Hydration Report".draw(at: CGPoint(x: 50, y: 50), withAttributes: titleAttributes)
        
        // Draw date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        "Generated on \(dateFormatter.string(from: Date()))".draw(
            at: CGPoint(x: 50, y: 80),
            withAttributes: bodyAttributes
        )
        
        var yPosition: CGFloat = 120
        
        // User Profile Section
        "User Profile".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: headerAttributes)
        yPosition += 30
        
        let profileInfo = [
            "Age: \(userProfile.age) years",
            "Weight: \(String(format: "%.1f", userProfile.weight)) kg",
            "Activity Level: \(userProfile.activityLevel.rawValue)",
            "Climate Zone: \(userProfile.climateZone.rawValue)"
        ]
        
        for info in profileInfo {
            info.draw(at: CGPoint(x: 70, y: yPosition), withAttributes: bodyAttributes)
            yPosition += 20
        }
        
        if !userProfile.healthConditions.isEmpty {
            yPosition += 10
            "Health Conditions:".draw(at: CGPoint(x: 70, y: yPosition), withAttributes: bodyAttributes)
            yPosition += 20
            
            for condition in userProfile.healthConditions {
                "• \(condition.name)".draw(at: CGPoint(x: 90, y: yPosition), withAttributes: bodyAttributes)
                yPosition += 20
            }
        }
        
        // Hydration Goals Section
        yPosition += 20
        "Hydration Goals and Progress".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: headerAttributes)
        yPosition += 30
        
        let dailyGoal = hydrationManager.dailyWaterGoal
        let currentIntake = hydrationManager.currentWaterIntake
        let percentage = (currentIntake / dailyGoal) * 100
        
        let hydrationInfo = [
            "Daily Goal: \(Int(dailyGoal))ml",
            "Current Intake: \(Int(currentIntake))ml",
            "Progress: \(Int(percentage))%"
        ]
        
        for info in hydrationInfo {
            info.draw(at: CGPoint(x: 70, y: yPosition), withAttributes: bodyAttributes)
            yPosition += 20
        }
        
        // Temperature-based recommendation
        if let temp = weatherService.temperature {
            yPosition += 20
            "Weather-based Recommendation".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: headerAttributes)
            yPosition += 30
            
            let recommendation = hydrationManager.getTemperatureBasedRecommendation()
            recommendation.draw(at: CGPoint(x: 70, y: yPosition), withAttributes: bodyAttributes)
            yPosition += 40
        }
        
        // Weekly Progress
        yPosition += 20
        "Weekly Progress".draw(at: CGPoint(x: 50, y: yPosition), withAttributes: headerAttributes)
        yPosition += 30
        
        let weekData = hydrationManager.dailyAverages(for: DateComponents(day: -7))
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM d"
        
        for (date, percentage) in weekData {
            "\(dateFormatter2.string(from: date)): \(Int(percentage))% of daily goal".draw(
                at: CGPoint(x: 70, y: yPosition),
                withAttributes: bodyAttributes
            )
            yPosition += 20
        }
        
        // End PDF context
        context.restoreGState()
        context.endPDFPage()
        context.closePDF()
        
        return pdfData as Data
    }
}

// Helper extension for drawing in PDF context
extension String {
    func draw(in rect: CGRect, withAttributes attributes: [NSAttributedString.Key: Any]) {
        let attributedString = NSAttributedString(string: self, attributes: attributes)
        attributedString.draw(in: rect)
    }
    
    func draw(at point: NSPoint, withAttributes attributes: [NSAttributedString.Key: Any]) {
        (self as NSString).draw(at: point, withAttributes: attributes)
    }
} 