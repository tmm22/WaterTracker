import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profile: UserProfile
    @EnvironmentObject var hydrationManager: HydrationManagerImpl
    @State private var showingSaveAlert = false
    @State private var temperatureInput: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.accentColor)
                    
                    Text("Profile Settings")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.vertical)
                
                // Personal Information
                GroupBox {
                    VStack(spacing: 16) {
                        LabeledContent("Age") {
                            TextField("Age", value: $profile.age, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                        }
                        
                        LabeledContent("Weight (kg)") {
                            TextField("Weight", value: $profile.weight, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Activity Level")
                                .font(.headline)
                            
                            Picker("Activity Level", selection: $profile.activityLevel) {
                                ForEach(ActivityLevel.allCases, id: \.self) { level in
                                    Text(level.rawValue).tag(level)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
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
                }
                
                // Temperature Settings
                GroupBox {
                    VStack(spacing: 16) {
                        HStack {
                            TextField("Current Temperature (°C)", text: $temperatureInput)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 150)
                            
                            Button("Update") {
                                if let temp = Double(temperatureInput) {
                                    profile.updateTemperature(temp)
                                    temperatureInput = ""
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(Double(temperatureInput) == nil)
                        }
                        
                        if let currentTemp = profile.currentTemperature {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Current Temperature: \(Int(currentTemp))°C")
                                    .font(.headline)
                                
                                Text(profile.getTemperatureBasedRecommendation())
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                } label: {
                    Label("Temperature Settings", systemImage: "thermometer")
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
                }
                
                // Save Button
                Button {
                    saveProfile()
                } label: {
                    Text("Save Profile")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
        }
        .frame(maxWidth: 600)
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