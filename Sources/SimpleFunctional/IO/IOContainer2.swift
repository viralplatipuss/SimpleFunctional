import Foundation

public extension MainFactory {
    static func createMain<StateType, H0: IOHandling, H1: IOHandling>(topLevelFunction: @escaping (StateType, IOContainer2<H0.IO, H1.IO>) -> (StateType, IOContainer2<H0.IO, H1.IO>),
                                                                      initialState: StateType,
                                                                      handlerTypes: (H0.Type, H1.Type)) -> Main {
        typealias IO = IOContainer2<H0.IO, H1.IO>
        let handlers = (H0(), H1())
        
        return .init(mainHelper: MainHelper(topLevelFunction: topLevelFunction,
                                            initialState: initialState,
                                            initialIO: .init()) { outputs, inp in
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs0, handler: handlers.0) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs1, handler: handlers.1) { inp(.create($0), $1) }
        })
    }
}


public struct IOContainer2<T0: IOType, T1: IOType>: IOContaining {
    
    // MARK: - Inputs
    
    public func input(forToken token: IOToken<T0>) -> T0.Input? {
        core.input(inputStorage: core.inputs.input0, token: token)
    }
    
    public func input(forToken token: IOToken<T1>) -> T1.Input? {
        core.input(inputStorage: core.inputs.input1, token: token)
    }
    
    // MARK: - Outputs
    
    public func addingOutput(_ output: T0.Output) -> (io: Self, token: IOToken<T0>) {
        core.updatingOutputs({ $0.copy(override0: $0.outputs0.adding((output, $1))) }) { .init(core: $0) }
    }
    
    public func addingOutput(_ output: T1.Output) -> (io: Self, token: IOToken<T1>) {
        core.updatingOutputs({ $0.copy(override1: $0.outputs1.adding((output, $1))) }) { .init(core: $0) }
    }
    
    
    // MARK: - Internal
    
    struct Inputs {
        
        static func create(_ input: T0.Input?) -> Self {
            .init(input0: input)
        }
        
        static func create(_ input: T1.Input?) -> Self {
            .init(input1: input)
        }
        
        fileprivate let input0: T0.Input?
        fileprivate let input1: T1.Input?
        
        fileprivate init(input0: T0.Input? = nil,
                         input1: T1.Input? = nil) {
            self.input0 = input0
            self.input1 = input1
        }
    }
    
    struct Outputs: OutputsCreating {
        
        typealias OT<T: IOType> = (T.Output, IOToken<T>)
        
        let outputs0: [OT<T0>]
        let outputs1: [OT<T1>]
        
        static func create() -> Self {
            .init(outputs0: [],
                  outputs1: [])
        }
        
        fileprivate func copy(override0: [OT<T0>]? = nil,
                              override1: [OT<T1>]? = nil) -> Self {
            .init(outputs0: override0 ?? outputs0,
                  outputs1: override1 ?? outputs1)
        }
    }
    
    let core: IOContainerCore<Inputs, Outputs>
    
    init(core: IOContainerCore<Inputs, Outputs> = .init(inputTokenId: nil, inputs: Inputs(), outputs: .create())) {
        self.core = core
    }
}


