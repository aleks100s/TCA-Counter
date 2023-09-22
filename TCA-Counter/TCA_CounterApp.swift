//
//  TCA_CounterApp.swift
//  TCA-Counter
//
//  Created by Alexander Stos on 22.09.2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_CounterApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: Store(initialState: CounterFeature.State()) {
                    CounterFeature()
                }
            )
        }
    }
}
