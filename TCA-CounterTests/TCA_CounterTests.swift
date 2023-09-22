//
//  TCA_CounterTests.swift
//  TCA-CounterTests
//
//  Created by Alexander Stos on 22.09.2023.
//

import XCTest
@testable import TCA_Counter
import ComposableArchitecture

@MainActor
final class TCA_CounterTests: XCTestCase {
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }

        await store.send(.incrementButtonTapped) {
            $0.count += 1
        }
    }

    func testTimer() async throws {
        let testClock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = testClock
        }

        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = true
        }
        await testClock.advance(by: .seconds(1))
        await store.receive(.timerTicked) {
            $0.count = 1
        }
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerOn = false
        }
    }

    func testGetFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { count in "\(count) is a great number!" }
        }

        await store.send(.getFactButtonTapped) {
            $0.isLoading = true
        }
        await store.receive(.factResponse("0 is a great number!")) {
            $0.fact = "0 is a great number!"
            $0.isLoading = false
        }
    }

    func testGetFact_Failure() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { _ in
                struct SomeError: Error {}
                throw SomeError()
            }
        }
        XCTExpectFailure()
        await store.send(.getFactButtonTapped) {
            $0.isLoading = true
        }
    }
}
