import SwiftUI

struct CaloriesCalculator {
    var durationMinutes: Int
    var distanceKm: Double
    var weightKg: Double

    private var hours: Double { Double(durationMinutes) / 60.0 }
    private var paceKmPerHour: Double { distanceKm / max(hours, 0.001) }

    // Renamed from calculateCaloriesBurned -> calculateTotalCalories
    func calculateTotalCalories() -> Int {
        let running = calculateRunningCalories()
        let walking = calculateWalkingCalories()
        let adjustments = adjustmentCalories(base: running + walking)
        return max(running + walking + adjustments, 0)
    }

    // Extracted from monolithic function
    func calculateRunningCalories() -> Int {
        let runMET: Double
        if paceKmPerHour >= 10 {
            runMET = 10.5
        } else if paceKmPerHour >= 8 {
            runMET = 9.0
        } else {
            runMET = 7.0
        }
        return Int((runMET * weightKg * hours).rounded())
    }

    // Separated walking logic
    func calculateWalkingCalories() -> Int {
        let walkMET: Double = 3.5
        return Int((walkMET * weightKg * hours * 0.2).rounded())
    }

    // Centralized adjustments; magic numbers made explicit
    func adjustmentCalories(base: Int) -> Int {
        var result = 0
        let hydrationPenalty = 25
        if durationMinutes > 90 { result += 50 }
        result -= hydrationPenalty
        return result
    }
}

struct ContentView: View {
    @State private var durationMinutes: Int = 30
    @State private var distanceKm: Double = 5.0
    @State private var weightKg: Double = 70.0
    @State private var totalCalories: Int = 0

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout")) {
                    Stepper("Duration: \(durationMinutes) min", value: $durationMinutes, in: 0...240)
                    Slider(value: $distanceKm, in: 0...30, step: 0.1) {
                        Text("Distance")
                    }
                    Text("Distance: \(distanceKm, specifier: "%.1f") km")
                    Slider(value: $weightKg, in: 35...150, step: 0.5) {
                        Text("Weight")
                    }
                    Text("Weight: \(weightKg, specifier: "%.1f") kg")
                }

                Section(header: Text("Calories")) {
                    Button("Calculate Calories") {
                        let calc = CaloriesCalculator(durationMinutes: durationMinutes, distanceKm: distanceKm, weightKg: weightKg)
                        totalCalories = calc.calculateTotalCalories()
                    }
                    Text("Total: \(totalCalories) kcal")
                }
            }
            .navigationTitle("Fitness (Refactored)")
        }
    }
}

#Preview {
    ContentView()
}
