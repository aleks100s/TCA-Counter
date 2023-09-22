//
//  ContentView.swift
//  TCA-Counter
//
//  Created by Alexander Stos on 22.09.2023.
//

import SwiftUI
import ComposableArchitecture

struct CounterView: View {
    let store: StoreOf<CounterFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            List {
                Section {
                    Text("\(viewStore.count)")
                    Button("Increment") {
                        viewStore.send(.incrementButtonTapped)
                    }
                    Button("Decrement") {
                        viewStore.send(.decrementButtonTapped)
                    }
                }

                Section {
                    Button("Get fact") {
                        viewStore.send(.getFactButtonTapped)
                    }
                    if viewStore.isLoading {
                        ProgressView()
                    }
                    if let fact = viewStore.fact {
                        Text(fact)
                    }
                }

                Section {
                    let title = viewStore.isTimerOn ? "Stop timer" : "Start timer"
                    Button(title) {
                        viewStore.send(.toggleTimerButtonTapped)
                    }
                }
            }
        }
    }
}

#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
                ._printChanges()
        }
    )
}
