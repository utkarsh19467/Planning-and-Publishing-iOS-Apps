import SwiftUI

struct ContentView: View {
    // Unrefactored: mixed concerns and monolithic function
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
                        totalCalories = calculateCaloriesBurned(duration: durationMinutes, distanceKm: distanceKm, weightKg: weightKg)
                    }
                    Text("Total: \(totalCalories) kcal")
                }
            }
            .navigationTitle("Fitness (Unrefactored)")
        }
    }

    // Exercise targets:
    // - Find all occurrences of this function with Cmd+Shift+F.
    // - Refactor > Extract to Method: pull out running calculation into `calculateRunningCalories()`.
    // - Refactor > Rename: rename this to `calculateTotalCalories`.
    func calculateCaloriesBurned(duration: Int, distanceKm: Double, weightKg: Double) -> Int {
        // Running calories (this block is a candidate to extract)
        // Very rough placeholder model: MET ~ 9.8 for running 10 km/h; calories = MET * weight(kg) * hours
        let hours = Double(duration) / 60.0
        let paceKmPerHour = distanceKm / max(hours, 0.001)
        let runMET: Double
        if paceKmPerHour >= 10 {
            runMET = 10.5
        } else if paceKmPerHour >= 8 {
            runMET = 9.0
        } else {
            runMET = 7.0
        }
        let runningCalories = Int((runMET * weightKg * hours).rounded())

        // Walking calories (mixed inline logic)
        let walkMET: Double = 3.5
        let walkingCalories = Int((walkMET * weightKg * hours * 0.2).rounded()) // pretend 20% of time walking

        // Arbitrary adjustments (magic numbers; not ideal)
        var result = runningCalories + walkingCalories
        let hydrationPenalty = 25 // TODO: make this configurable
        if duration > 90 {
            result += 50 // bonus for long session
        }
        result -= hydrationPenalty

        return max(result, 0)
    }
}

#Preview {
    ContentView()
}
