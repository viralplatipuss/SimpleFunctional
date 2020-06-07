import Foundation

/// Represents a pure app, that can be run with IO.
public protocol PureAppProviding {
    associatedtype IOType: IO
    
    func run(input: IOType.Input?) -> (app: Self, outputs: [IOType.Output])?
}
