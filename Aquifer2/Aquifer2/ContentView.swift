//
//  ContentView.swift
//  Aquifer2
//
//  Created by Shanti Isaac on 10/28/23.
//
import SwiftUI

struct ContentView: View {
    @State private var ageGroup = 0
    @State private var gender = 0
    @State private var isAthlete = false
    @State private var waterIntake = 0.0
    
    let ageGroups = ["1-3 years", "4-8 years", "9-13 years", "14-18 years", "19 and older"]
    let genders = ["Male", "Female", "Prefer Not to Specify"]
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("Aquifer1BG")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .topLeading)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Form {
                        Section {
                            Picker("Select Age Group", selection: $ageGroup) {
                                ForEach(0..<ageGroups.count, id: \.self) { index in
                                    Text(ageGroups[index])
                                }
                            }
                            
                            Picker("Select Gender", selection: $gender) {
                                ForEach(0..<genders.count, id: \.self) { index in
                                    Text(genders[index])
                                }
                            }
                            
                            Toggle("Athlete", isOn: $isAthlete)
                        }
                        
                        Section(header: Text("Recommended Daily Water Intake")) {
                            Text("\(calculateWaterIntake()) cups (\(calculateWaterIntake() * 8) ounces)")
                        }
                        
                    }
                    .background(Color.white) // Add a semi-transparent white background to the form
                    .frame(height: 350.0)
                    .cornerRadius(20)
                    
                }
                .padding(12.0)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
    
    func calculateWaterIntake() -> Double {
        var waterIntake: Double = 0.0
        
        if ageGroup <= 1 { // 1-3 years or 4-8 years
            waterIntake = ageGroup == 0 ? 4.0 : 5.0
        } else if ageGroup <= 3 { // 9-13 years or 14-18 years (non-athlete)
            waterIntake = ageGroup == 2 ? 7.5 : 9.0
            
        } else { // Age group 19 and older or athlete in the younger age groups
            let genderIndex = gender == 2 ? 1 : gender
            let ageGroupIndex = ageGroup == 4 ? (isAthlete ? 2 : 1) : (ageGroup == 3 ? 3 : ageGroup)
            
            let values: [[Double]] = [
                [10.0, 9.0, (10.0 + 9.0) / 2.0], // 9-13 (male athletes)
                [9.0, 9.0, 9.0], // 9-13 (female athletes)
                [14.0, 10.0, (14.0 + 10.0) / 2.0], // 14-18 (male athletes)
                [10.0, 9.0, (10.0 + 9.0) / 2.0], // 14-18 (female athletes)
                [24.0, (24.0 + 16.5) / 2.0, 16.5], // 19 and older (male athletes)
                [16.5, 16.5, 16.5], // 19 and older (female athletes)
                [(13.0 + 9.0) / 2.0, (13.0 + 9.0) / 2.0, (13.0 + 9.0) / 2.0] // 19 and older (non-athlete)
            ]
            
            waterIntake = values[ageGroupIndex][genderIndex]
        }
        
        return waterIntake
    }
    
    struct WaterIntakeApp: App {
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
        }
    }
}

#Preview {
    ContentView()
}
