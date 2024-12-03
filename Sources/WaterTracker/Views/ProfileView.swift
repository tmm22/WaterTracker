import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var hydrationManager: HydrationManagerImpl
    @State private var showingSaveAlert = false
    @State private var temperatureInput: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.accentColor, .accentColor.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text("Profile Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.vertical)
                    
                    // Personal Information
                    GroupBox {
                        VStack(spacing: 20) {
                            // Basic Info
                            VStack(spacing: 16) {
                                HStack {
                                    Text("Age")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    TextField("Age", value: $profile.age, format: .number)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 100)
                                        .multilineTextAlignment(.trailing)
                                }
                                
                                HStack {
                                    Text("Weight (kg)")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    TextField("Weight", value: $profile.weight, format: .number)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 100)
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                            
                            Divider()
                            
                            // Activity Level
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Activity Level")
                                    .font(.headline)
                                
                                Picker("Activity Level", selection: $profile.activityLevel) {
                                    ForEach(ActivityLevel.allCases, id: \.self) { level in
                                        Text(level.rawValue).tag(level)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            
                            // Climate Zone
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Climate Zone")
                                    .font(.headline)
                                
                                Picker("Climate Zone", selection: $profile.climateZone) {
                                    ForEach(ClimateZone.allCases, id: \.self) { zone in
                                        Text(zone.rawValue).tag(zone)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }
                        .padding()
                    } label: {
                        Label("Personal Information", systemImage: "person.text.rectangle")
                            .font(.headline)
                    }
                    
                    // Temperature Settings
                    GroupBox {
                        VStack(spacing: 20) {
                            HStack {
                                TextField("Current Temperature (°C)", text: $temperatureInput)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(maxWidth: .infinity)
                                
                                Button {
                                    if let temp = Double(temperatureInput) {
                                        profile.updateTemperature(temp)
                                        temperatureInput = ""
                                    }
                                } label: {
                                    Text("Update")
                                        .frame(width: 80)
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(Double(temperatureInput) == nil)
                            }
                            
                            if let currentTemp = profile.currentTemperature {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "thermometer")
                                            .foregroundColor(.accentColor)
                                        Text("\(Int(currentTemp))°C")
                                            .font(.headline)
                                    }
                                    
                                    Text(profile.getTemperatureBasedRecommendation())
                                        .font(.callout)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(colorScheme == .dark ? 
                                            Color(.windowBackgroundColor) : 
                                            Color(.textBackgroundColor))
                                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                )
                            }
                        }
                        .padding()
                    } label: {
                        Label("Temperature Settings", systemImage: "thermometer")
                            .font(.headline)
                    }
                    
                    // Health Conditions
                    GroupBox {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(HealthCondition.allCases, id: \.self) { condition in
                                Toggle(condition.name, isOn: Binding(
                                    get: { profile.healthConditions.contains(condition) },
                                    set: { isEnabled in
                                        if isEnabled {
                                            profile.healthConditions.insert(condition)
                                        } else {
                                            profile.healthConditions.remove(condition)
                                        }
                                    }
                                ))
                                .toggleStyle(.switch)
                            }
                        }
                        .padding()
                    } label: {
                        Label("Health Conditions", systemImage: "heart.text.square")
                            .font(.headline)
                    }
                    
                    // Save Button
                    Button {
                        saveProfile()
                    } label: {
                        Text("Save Profile")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.accentColor)
                            )
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
        }
        .background(colorScheme == .dark ? Color(.windowBackgroundColor) : Color(.textBackgroundColor))
        .alert("Profile Saved", isPresented: $showingSaveAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your profile has been updated and your daily water goal has been recalculated.")
        }
    }
    
    private func saveProfile() {
        hydrationManager.dailyWaterGoal = profile.calculateDailyWaterGoal()
        showingSaveAlert = true
    }
} 