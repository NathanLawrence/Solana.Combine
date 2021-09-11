// NL 2021

import Foundation
import Combine

/// An implementation-erased publisher coming from the `SolanaPublishers` framework.
public struct SolanaPublisher<Output, Failure: Error>: CustomStringConvertible, CustomPlaygroundDisplayConvertible {
    @usableFromInline
    internal let box: SolanaCombineBox<Output, Failure>

    @inlinable
    public init<T: Publisher>(_ publisher: T) where Output == T.Output, Failure == T.Failure {
        if let erased = publisher as? SolanaPublisher<Output, Failure> {
            box = erased.box
        } else {
            box = SolanaCombineSpecificBox(base: publisher)
        }
    }

    public var description: String {
        return "SolanaPublisher"
    }

    public var playgroundDescription: Any {
        return description
    }
}

extension SolanaPublisher: Publisher {
    @inlinable
    public func receive<Downstream: Subscriber>(subscriber: Downstream)
    where Output == Downstream.Input, Failure == Downstream.Failure
    {
        box.receive(subscriber: subscriber)
    }
}

/// By creating a base class that does not care about publisher types,
/// we can erase our references to this type while preserving functional details for dispatch.
/// NOTE: In order to inline (which is necessary for performance reasons), this must be internal, not private.
@usableFromInline
internal class SolanaCombineBox<Output, Failure: Error>: Publisher {
    @inlinable
    internal init() {}

    @usableFromInline
    internal func receive<Target: Subscriber>(subscriber: Target)
    where Failure == Target.Failure, Output == Target.Input {
        fatalError("Never use the abstract class, always subclass.")
    }
}

/// This concrete subclass is generic around the publisher details,
/// but we won't address it directly.
/// NOTE: In order to inline (which is necessary for performance reasons), this must be internal, not private.
@usableFromInline
internal final class SolanaCombineSpecificBox<BoxedPublisher: Publisher> : SolanaCombineBox<BoxedPublisher.Output, BoxedPublisher.Failure> {
    @usableFromInline
    internal let base: BoxedPublisher

    @inlinable
    internal init(base: BoxedPublisher) {
        self.base = base
        super.init()
    }

    @inlinable
    override internal func receive<Downstream: Subscriber>(subscriber: Downstream) where Failure == Downstream.Failure, Output == Downstream.Input {
        base.receive(subscriber: subscriber)
    }
}
