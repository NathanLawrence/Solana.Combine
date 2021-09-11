// NL 2021

import Foundation
import Combine
import Solana

public extension Action {
    /// Retrieve a publisher for the given action.
    /// When this publisher is subscribed to, it will immediately begin any necessary requests and emit the results.
    func publisher<T: ActionTemplate>(for actionTemplate: T) -> SolanaPublisher<T.Success, Error> {
        let future = Future<T.Success, Error> { promise in
            self.perform(actionTemplate) { promise($0) }
        }

        return SolanaPublisher(future)
    }
}
