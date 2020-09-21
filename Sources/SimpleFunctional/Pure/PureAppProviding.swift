import Foundation

/// Protocol for a pure app, that can be run with IO.
/// This should typically be a struct with no mutable state.
public protocol PureAppProviding {
    
    /// The IO type the app runs using.
    associatedtype IOType: IO
    
    typealias Input = IOType.Input
    typealias Output = IOType.Output
    
    /// Runs the app's current state with an input. Or no input for the first run.
    /// Returns a copy of the app with updated state and any outputs to be handled outside of the pure app.
    func run(input: Input?) -> (app: Self, outputs: [Output])?
}
