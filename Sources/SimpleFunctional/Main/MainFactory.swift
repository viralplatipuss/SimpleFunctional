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
    
    /// Creates a Main instance for use with 1 IOHandler.
    public static func createMain<StateType, H0: IOHandling>(topLevelFunction: @escaping (StateType, IOContainer1<H0.IO>) -> (StateType, IOContainer1<H0.IO>),
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
