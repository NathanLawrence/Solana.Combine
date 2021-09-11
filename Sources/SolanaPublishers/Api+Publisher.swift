// NL 2021

import Foundation
import Combine
import Solana

public extension Api {
    // Retrieve a publisher for the given API call.
    /// When this publisher is subscribed to, it will immediately begin any necessary requests and emit the results.
    func publisher<T: ApiTemplate>(for apiTemplate: T) -> SolanaPublisher<T.Success, Error> {
        let future = Future<T.Success, Error> { promise in
            self.perform(apiTemplate) { promise($0) }
        }

        return SolanaPublisher(future)
    }
}
