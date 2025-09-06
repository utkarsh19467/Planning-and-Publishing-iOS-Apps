# Fitness App Projects (SwiftUI)

This directory contains two SwiftUI app source trees you can open in Xcode on macOS:

- FitnessApp-Unrefactored: Unrefactored version with a monolithic `calculateCaloriesBurned` function and mixed concerns.
- FitnessApp-Refactored: Refactored version showing Extract Method (`calculateRunningCalories`) and Rename (`calculateTotalCalories`).

Note: .xcodeproj files are intentionally not hand-crafted here (fragile to hand-author). Use the steps below to create the two Xcode projects quickly and copy these sources in.

## Create each Xcode project (repeat for both folders)

1. Open Xcode on your Mac.
2. File > New > Project… > iOS > App > Next.
3. Product Name: match the folder name (e.g., `FitnessApp-Unrefactored`), Interface: SwiftUI, Language: Swift.
4. Save the project inside the matching folder here (e.g., `xcode-project/FitnessApp-Unrefactored`).
5. In Xcode, replace the generated `App` and `ContentView` files with the ones provided in the folder. Add the `Info.plist` if prompted.
6. Build and run (Cmd+R).

## What to explore

- Global Find (Cmd+Shift+F) for `calculateCaloriesBurned` / `calculateTotalCalories`.
- In Unrefactored:
  - Try Refactor > Extract to Method on the running-logic section.
  - Try Refactor > Rename of `calculateCaloriesBurned`.
- In Refactored:
  - See `calculateRunningCalories()` and `calculateTotalCalories()` in use.

Minimum iOS target: 15.0.

If Xcode offers to “Update” project settings, accept.
