# Solana.Combine

Extend the functionality of Solana.Swift with Combine publishers.

## In Use

Add `Solana.Combine` to your Swift packages, then simply import `SolanaPublishers`.

Then, you can treat your Combine publishers out of Solana exactly as you would any other publisher. 

Calls are made by providing an `ActionTemplate` or `ApiTemplate` to an `Action` or `Api` object with the `publisher(for:)` method.

```swift
import Foundation
import Combine
import Solana
import SolanaPublishers

public class SolanaDemoViewModel: ObservableObject {
    @Published var wallets: [Wallet]?

    func getAccountInfo() {
        // configure the "Action" class exactly as you would normally
        let action = Action(...) 
        
        // Build a request with the ActionTemplate representing what you want to do.
        let request = ActionTemplates.GetTokenWallets(...) 
        
        action
            // Ask the Action class for a publisher of your request's results.
            .publisher(for: request)
            // In production, you actually want to handle errors, of course.
            .assertNoFailure()
            .assign(to: &$wallets)
    }
}
```
