import Foundation

/// IO handlers confrom to this protocol in order to handle incoming outputs and return inputs.
public protocol IOHandling: class {
    
    /// The type of IO this handler handles.
    associatedtype IO: IOType
    
    /// Implement to handle an output and generate an input, if needed.
    func handle(output: IO.Output, token: IOToken<IO>, inputClosure: (IO.Input) -> Void)
    
    /// Create the handler.
    init()
}

/// Represents a type of IO. Each IO type should inherit this protocol and define its own input and output structs.
public protocol IOType {
    
    associatedtype Input
    
    associatedtype Output
}

protocol IOContaining {
    associatedtype Inputs
    associatedtype Outputs: OutputsCreating
    
    init(core: IOContainerCore<Inputs, Outputs>)
    var core: IOContainerCore<Inputs, Outputs> { get }
}

protocol OutputsCreating {
    static func create() -> Self
}
