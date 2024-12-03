import Foundation
import CoreLocation

enum WeatherError: Error {
    case locationNotAuthorized
    case locationError(Error)
    case networkError(Error)
    case invalidAPIKey
    case invalidResponse
    case noData
    
    var description: String {
        switch self {
        case .locationNotAuthorized:
            return "Location access not authorized. Please enable location services in System Settings."
        case .locationError(let error):
            return "Location error: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidAPIKey:
            return "Invalid or missing API key. Please check your OpenWeatherMap API key."
        case .invalidResponse:
            return "Invalid response from weather service"
        case .noData:
            return "No weather data available"
        }
    }
}

@MainActor
class WeatherService: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var temperature: Double?
    @Published var isLoading = false
    @Published var error: WeatherError?
    
    private let locationManager = CLLocationManager()
    private let apiKey = "625818d31eec539e08d410b42609bf22"
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        print("WeatherService initialized")
    }
    
    func requestLocation() async {
        print("Requesting location access...")
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        let status = locationManager.authorizationStatus
        print("Current location authorization status: \(status.rawValue)")
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .denied, .restricted:
            await MainActor.run {
                isLoading = false
                error = .locationNotAuthorized
            }
            print("Location access denied or restricted")
        @unknown default:
            await MainActor.run {
                isLoading = false
                error = .locationNotAuthorized
            }
            print("Unknown location authorization status")
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            print("No location data available")
            Task { @MainActor in
                isLoading = false
                error = .noData
            }
            return
        }
        
        print("Location received: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        Task {
            await fetchWeather(for: location)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed: \(error.localizedDescription)")
        if let clError = error as? CLError {
            print("CLError code: \(clError.code.rawValue)")
        }
        Task { @MainActor in
            self.isLoading = false
            self.error = .locationError(error)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location authorization status changed to: \(status.rawValue)")
        Task { @MainActor in
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.requestLocation()
            case .denied, .restricted:
                isLoading = false
                error = .locationNotAuthorized
            default:
                break
            }
        }
    }
    
    private func fetchWeather(for location: CLLocation) async {
        print("Fetching weather data...")
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            isLoading = false
            error = .invalidResponse
            return
        }
        
        print("Making API request to OpenWeather...")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response type")
                error = .invalidResponse
                isLoading = false
                return
            }
            
            print("Received response with status code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 401 {
                print("API Key error")
                error = .invalidAPIKey
                isLoading = false
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                print("Invalid response status: \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response body: \(responseString)")
                }
                error = .invalidResponse
                isLoading = false
                return
            }
            
            let decoder = JSONDecoder()
            let weather = try decoder.decode(WeatherResponse.self, from: data)
            print("Successfully decoded weather data: \(weather.main.temp)°C")
            self.temperature = weather.main.temp
            self.error = nil
            
        } catch {
            print("Error fetching weather: \(error.localizedDescription)")
            self.error = .networkError(error)
        }
        
        isLoading = false
    }
}

struct WeatherResponse: Codable {
    struct Main: Codable {
        let temp: Double
    }
    let main: Main
} 