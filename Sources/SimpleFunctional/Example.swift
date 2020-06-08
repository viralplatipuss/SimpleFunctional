// =============================================================
// Below is an example of how to use the library, by setting up
// IO types and handlers. As well as an ImpureApp that wraps
// your functionally pure application.
// =============================================================

/*

 import Foundation
 import SimpleFunctional
 
// MARK: - Impure Code

// This is all the functionally impure code needed to handle IO outside the pure functional application.

// MARK: - IO Handlers

/// A sample IO Handler that allows the app to request printing something to the console.
final class ConsoleIOHandler: IOHandling {
    typealias IOType = ConsoleIO
    
    func handle(output: IOType.Output, inputClosure: @escaping (IOType.Input) -> Void) {
        switch output {
        case .print(let message):
            print(message)
            inputClosure(.didPrint(message: message))
        }
    }
}

/// Another sample IO Handler, for handling timers.
final class TimerIOHandler: IOHandling {
    typealias IOType = TimerIO
    
    func handle(output: IOType.Output, inputClosure: @escaping (IOType.Input) -> Void) {
        guard case let IOType.Output.addTimer(id, milliseconds) = output else { return }
        
        queue.asyncAfter(deadline: .now() + .milliseconds(Int(milliseconds))) {
            inputClosure(.timerFired(id: id))
        }
    }
    
    private let queue = DispatchQueue(label: "TimerIOHandler.queue", attributes: .concurrent)
}

/// The IO handler for the app itself, which contains all the other IO handlers.
/// This approach can also be used to create sub-IO Handlers within IO Handlers.
final class AppIOHandler: IOHandling {
    typealias IOType = AppIO
    
    func handle(output: IOType.Output, inputClosure: @escaping (IOType.Input) -> Void) {
        switch output {
        case .console(let o): return consoleHandler.handle(output: o, inputClosure: { inputClosure(.console($0)) })
        case .timer(let o): return timerHandler.handle(output: o, inputClosure: { inputClosure(.timer($0)) })
        }
    }
    
    private let consoleHandler = ConsoleIOHandler()
    private let timerHandler = TimerIOHandler()
}

// MARK - Impure App

// Create and start an impure app, wrapping the pure app and the app's IO handler.
// This should be done as early in the application as possible, with the impureApp property being kept alive by the AppDelegate or similar.

// let impureApp = ImpureApp(pureApp: App(), ioHandler: AppIOHandler())
// impureApp.start()



// MARK: - Pure

// All the following code is functionally pure. It exists mainly with structs using no mutable state.
// As much of your application as possible should be functionally pure and separated from impure code.

// MARK: - IO

/// An IO type for interacting with the console.
struct ConsoleIO: IO {
    enum Input {
        case didPrint(message: String)
    }
    
    enum Output {
        case print(message: String)
    }
}

/// An IO type for timers.
struct TimerIO: IO {
    enum Input {
        case timerFired(id: UInt)
    }
    
    enum Output {
        case addTimer(id: UInt, milliseconds: UInt)
    }
}

/// The IO type for the whole App, containing the other IO types.
struct AppIO: IO {
    
    typealias IOA = ConsoleIO
    typealias IOB = TimerIO
    
    typealias Input = IO<IOA.Input, IOB.Input>
    typealias Output = IO<IOA.Output, IOB.Output>
    
    enum IO<A, B> {
        case console(A)
        case timer(B)
    }
}

// MARK: - App

/// The functionally pure entry point for the application.
struct App: PureAppProviding {
    
    typealias Input = AppIO.Input
    typealias Output = AppIO.Output
    
    /// The run function is called with an input, and returns an updated app and any outputs to request.
    /// The outputs are then run in the impure code outside of this app, which will then run this function again with any inputs that are generated.
    func run(input: Input?) -> (app: Self, outputs: [Output])? {
        guard let _ = input else {
            return (self, [.console(.print(message: "Hello World!"))])
        }
        
        return nil
    }    
}

 */
