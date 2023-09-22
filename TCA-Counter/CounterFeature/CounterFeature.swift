import Foundation
import ComposableArchitecture

struct CounterFeature: Reducer {
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isTimerOn = false
        var isLoading = false
    }

    enum Action: Equatable {
        case decrementButtonTapped
        case incrementButtonTapped
        case getFactButtonTapped
        case toggleTimerButtonTapped
        case factResponse(String?)
        case timerTicked
    }

    private enum CancelID {
        case timer
    }

    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFactClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.fact = nil
                state.count -= 1
                return .none

            case .incrementButtonTapped:
                state.fact = nil
                state.count += 1
                return .none

            case .getFactButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [number = state.count] send in
                    let fact = try await self.numberFactClient.fetch(number)
                    await send(.factResponse(fact))
                }

            case .toggleTimerButtonTapped:
                state.isTimerOn.toggle()
                if state.isTimerOn {
                    return .run { send in
                        for await _ in self.clock.timer(interval: .seconds(1)) {
                            await send(.timerTicked)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }

            case let .factResponse(response):
                state.isLoading = false
                state.fact = response
                return .none

            case .timerTicked:
                state.count += 1
                return .none
            }
        }
    }
}
