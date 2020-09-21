import Foundation

/// An IOHandler handles outputs from a pure app, and generates inputs that should be run on the app.
public protocol IOHandling {
    associatedtype IOType: IO
    
    typealias Input = IOType.Input
    typealias Output = IOType.Output
    
    /// Handles an output from a pure app.
    func handle(output: Output)
}
