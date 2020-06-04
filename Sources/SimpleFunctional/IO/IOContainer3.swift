import Foundation

public extension MainFactory {
    static func createMain<StateType, H0: IOHandling, H1: IOHandling, H2: IOHandling>(topLevelFunction: @escaping (StateType, IOContainer3<H0.IO, H1.IO, H2.IO>) -> (StateType, IOContainer3<H0.IO, H1.IO, H2.IO>)?,
                                                                                      initialState: StateType,
                                                                                      handlerTypes: (H0.Type, H1.Type, H2.Type)) -> Main {
        typealias IO = IOContainer3<H0.IO, H1.IO, H2.IO>
        let handlers = (H0(), H1(), H2())
        
        return .init(mainHelper: MainHelper(topLevelFunction: topLevelFunction,
                                            initialState: initialState,
                                            initialIO: .init()) { outputs, inp in
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs0, handler: handlers.0) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs1, handler: handlers.1) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs2, handler: handlers.2) { inp(.create($0), $1) }
        })
    }
}


public struct IOContainer3<T0: IOType, T1: IOType, T2: IOType>: IOContaining {
    
    // MARK: - Inputs
    
    public func input(forToken token: IOToken<T0>) -> T0.Input? {
        core.input(inputStorage: core.inputs.input0, token: token)
    }
    
    public func input(forToken token: IOToken<T1>) -> T1.Input? {
        core.input(inputStorage: core.inputs.input1, token: token)
    }
    
    public func input(forToken token: IOToken<T2>) -> T2.Input? {
        core.input(inputStorage: core.inputs.input2, token: token)
    }
    
    // MARK: - Outputs
    
    public func addingOutput(_ output: T0.Output) -> (io: Self, token: IOToken<T0>) {
        core.updatingOutputs({ $0.copy(override0: $0.outputs0.adding((output, $1))) }) { .init(core: $0) }
    }
    
    public func addingOutput(_ output: T1.Output) -> (io: Self, token: IOToken<T1>) {
        core.updatingOutputs({ $0.copy(override1: $0.outputs1.adding((output, $1))) }) { .init(core: $0) }
    }
    
    public func addingOutput(_ output: T2.Output) -> (io: Self, token: IOToken<T2>) {
        core.updatingOutputs({ $0.copy(override2: $0.outputs2.adding((output, $1))) }) { .init(core: $0) }
    }
    
    
    // MARK: - Internal
    
    struct Inputs {
        
        static func create(_ input: T0.Input?) -> Self {
            .init(input0: input)
        }
        
        static func create(_ input: T1.Input?) -> Self {
            .init(input1: input)
        }
        
        static func create(_ input: T2.Input?) -> Self {
            .init(input2: input)
        }
        
        fileprivate let input0: T0.Input?
        fileprivate let input1: T1.Input?
        fileprivate let input2: T2.Input?
        
        fileprivate init(input0: T0.Input? = nil,
                         input1: T1.Input? = nil,
                         input2: T2.Input? = nil) {
            self.input0 = input0
            self.input1 = input1
            self.input2 = input2
        }
    }
    
    struct Outputs: OutputsCreating {
        
        typealias OT<T: IOType> = (T.Output, IOToken<T>)
        
        let outputs0: [OT<T0>]
        let outputs1: [OT<T1>]
        let outputs2: [OT<T2>]
        
        static func create() -> Self {
            .init(outputs0: [],
                  outputs1: [],
                  outputs2: [])
        }
        
        fileprivate func copy(override0: [OT<T0>]? = nil,
                              override1: [OT<T1>]? = nil,
                              override2: [OT<T2>]? = nil) -> Self {
            .init(outputs0: override0 ?? outputs0,
                  outputs1: override1 ?? outputs1,
                  outputs2: override2 ?? outputs2)
        }
    }
    
    let core: IOContainerCore<Inputs, Outputs>
    
    init(core: IOContainerCore<Inputs, Outputs> = .init(inputTokenId: nil, inputs: Inputs(), outputs: .create())) {
        self.core = core
    }
}


