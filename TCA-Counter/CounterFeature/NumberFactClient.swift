//
//  NumberFactClient.swift
//  TCA-Counter
//
//  Created by Alexander Stos on 22.09.2023.
//

import Foundation
import ComposableArchitecture

struct NumberFactClient {
    var fetch: @Sendable (Int) async throws -> String?
}

extension NumberFactClient: DependencyKey {
    static let liveValue = Self { number in
        guard let url = URL(string: "http://www.numbersapi.com/\(number)") else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)
        let fact = String(data: data, encoding: .utf8)
        return fact
    }
}

extension DependencyValues {
    var numberFact: NumberFactClient {
        get {
            self[NumberFactClient.self]
        }
        set {
            self[NumberFactClient.self] = newValue
        }
    }
}
