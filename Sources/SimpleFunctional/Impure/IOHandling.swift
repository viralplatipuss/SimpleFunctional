import Foundation

/// An IOHandler handles outputs from a pure app, and generates inputs that should be run.
public protocol IOHandling {
    associatedtype IOType: IO
    
    func handle(output: IOType.Output, inputClosure: @escaping (IOType.Input) -> Void)
}
