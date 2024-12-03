import SwiftUI
import UserNotifications

@main
struct WaterTrackerApp: App {
    @StateObject private var hydrationManager = HydrationManagerImpl()
    @StateObject private var userProfile = UserProfile()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Track", systemImage: "drop.fill")
                    }
                    .environmentObject(hydrationManager)
                    .environmentObject(userProfile)
                
                HydrationTrendsView(hydrationManager: hydrationManager)
                    .tabItem {
                        Label("Trends", systemImage: "chart.xyaxis.line")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
                    .environmentObject(userProfile)
                    .environmentObject(hydrationManager)
            }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
} 