import Foundation

/// An IOHandler handles outputs from a pure app, and generates inputs that should be run on the app.
public protocol IOHandling {
    associatedtype IOType: IO
    
    typealias Input = IOType.Input
    typealias Output = IOType.Output
    
    /// Handles an output from a pure app.
    func handle(output: Output)
}

/// Base class for an IOHandler.
/// Subclass this to create an IOHandler for the pure app.
/// The handle(output:) function should be overriden to handle outputs and generate needed inputs.
/// The runInput() function can be called to run an input on the pure app if required.
open class BaseIOHandler<IOType: IO>: IOHandling {
    
    /// Creates the IOHandler with the given runInputClosure.
    public init(runInputClosure: @escaping (Input) -> Void) {
        self.runInputClosure = runInputClosure
    }
    
    /// Handles an output.
    /// This should be overriden in the subclass to handle the outputs.
    open func handle(output: Output) {
        fatalError("handle(output:) should be overriden by subclass.")
        // Subclass should handle output here.
        // Call runInput() to run inputs as a result of handling an output.
    }
    
    /// Runs an input on the pure app.
    /// This can be called by the subclass to run inputs.
    public final func runInput(_ input: Input) {
        runInputClosure(input)
    }
    
    
    // MARK: - Private
    
    private let runInputClosure: (Input) -> Void
}
