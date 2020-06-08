import Foundation

/// Represents a pure app, that can be run with IO.
public protocol PureAppProviding {
    associatedtype Input
    associatedtype Output
    
    func run(input: Input?) -> (app: Self, outputs: [Output])?
}
