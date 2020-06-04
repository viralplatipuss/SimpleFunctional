import Foundation

/// The main class is the top level object for running your functional program and handling IO.
/// Create one using MainFactory.
/// Main will run your program once start() is called, for as long as the Main instance is kept alive.
public class Main {
    
    public func start() {
        mainHelper.start()
    }
    
    // MARK: - Internal
    
    init(mainHelper: MainHelping) {
        self.mainHelper = mainHelper
    }
    
    // MARK: - Private
    
    private let mainHelper: MainHelping
}


/// MainFactory builds Main instances that run your pure top level function and handle IO. There are multiple methods for creating compile-time safe Mains using different numbers of IO Handlers. See each IOContainer swift file.
public final class MainFactory {
    
    /**
     Creates a Main instance for use with 1 IOHandler.
     - parameter topLevelFunction: The top-most function of the pure functional app.
                                   It takes a state and an IO container, and should return an updated state and updated IO container.
                                   As a convenience, it can also return nil if there were no changes to state or IO.
     - parameter initialState: This is the top-most state for the pure functional app. It should be a struct with all immutable properties. The copy of the state given to this function will be the first state used to run the topLevelFunction.
     - parameter handlerType: This is the type of the IOHandler class that should be used to handle the 1 IO type. The IO type is inferred from the Handler type, and will be automatically passed into your topLevelFunction.
    **/
    public static func createMain<StateType, H0: IOHandling>(topLevelFunction: @escaping (StateType, IOContainer1<H0.IO>) -> (StateType, IOContainer1<H0.IO>)?,
                                                                                             initialState: StateType,
                                                                                             handlerType: H0.Type) -> Main {
        typealias IO = IOContainer1<H0.IO>
        let handler = H0()
        
        return .init(mainHelper: MainHelper(topLevelFunction: topLevelFunction,
                                            initialState: initialState,
                                            initialIO: .init()) { outputs, inp in
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs0, handler: handler) { inp(.create($0), $1) }
        })
    }
}
