//
//  TryHealthKitApp.swift
//  TryHealthKit
//
//  Created by Alvito . on 05/05/23.
//

import SwiftUI
import Firebase

@main
struct TryHealthKitApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(HealthKitViewModel())
                .environmentObject(WriteViewModel())
                .environmentObject(ReadViewModel())
        }
    }
}
