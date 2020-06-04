import Foundation

public extension MainFactory {
    static func createMain<StateType, H0: IOHandling, H1: IOHandling, H2: IOHandling, H3: IOHandling>(topLevelFunction: @escaping (StateType, IOContainer4<H0.IO, H1.IO, H2.IO, H3.IO>) -> (StateType, IOContainer4<H0.IO, H1.IO, H2.IO, H3.IO>)?,
                                                                                                      initialState: StateType,
                                                                                                      handlerTypes: (H0.Type, H1.Type, H2.Type, H3.Type)) -> Main {
        typealias IO = IOContainer4<H0.IO, H1.IO, H2.IO, H3.IO>
        let handlers = (H0(), H1(), H2(), H3())
        
        return .init(mainHelper: MainHelper(topLevelFunction: topLevelFunction,
                                            initialState: initialState,
                                            initialIO: .init()) { outputs, inp in
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs0, handler: handlers.0) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs1, handler: handlers.1) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs2, handler: handlers.2) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs3, handler: handlers.3) { inp(.create($0), $1) }
        })
    }
}


public struct IOContainer4<T0: IOType, T1: IOType, T2: IOType, T3: IOType>: IOContaining {
    
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
    
    public func input(forToken token: IOToken<T3>) -> T3.Input? {
        core.input(inputStorage: core.inputs.input3, token: token)
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
    
    public func addingOutput(_ output: T3.Output) -> (io: Self, token: IOToken<T3>) {
        core.updatingOutputs({ $0.copy(override3: $0.outputs3.adding((output, $1))) }) { .init(core: $0) }
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
        
        static func create(_ input: T3.Input?) -> Self {
            .init(input3: input)
        }
        
        fileprivate let input0: T0.Input?
        fileprivate let input1: T1.Input?
        fileprivate let input2: T2.Input?
        fileprivate let input3: T3.Input?
        
        fileprivate init(input0: T0.Input? = nil,
                         input1: T1.Input? = nil,
                         input2: T2.Input? = nil,
                         input3: T3.Input? = nil) {
            self.input0 = input0
            self.input1 = input1
            self.input2 = input2
            self.input3 = input3
        }
    }
    
    struct Outputs: OutputsCreating {
        
        typealias OT<T: IOType> = (T.Output, IOToken<T>)
        
        let outputs0: [OT<T0>]
        let outputs1: [OT<T1>]
        let outputs2: [OT<T2>]
        let outputs3: [OT<T3>]
        
        static func create() -> Self {
            .init(outputs0: [],
                  outputs1: [],
                  outputs2: [],
                  outputs3: [])
        }
        
        fileprivate func copy(override0: [OT<T0>]? = nil,
                              override1: [OT<T1>]? = nil,
                              override2: [OT<T2>]? = nil,
                              override3: [OT<T3>]? = nil) -> Self {
            .init(outputs0: override0 ?? outputs0,
                  outputs1: override1 ?? outputs1,
                  outputs2: override2 ?? outputs2,
                  outputs3: override3 ?? outputs3)
        }
    }
    
    let core: IOContainerCore<Inputs, Outputs>
    
    init(core: IOContainerCore<Inputs, Outputs> = .init(inputTokenId: nil, inputs: Inputs(), outputs: .create())) {
        self.core = core
    }
}


