import Foundation

public extension MainFactory {
    static func createMain<StateType, H0: IOHandling, H1: IOHandling, H2: IOHandling, H3: IOHandling, H4: IOHandling, H5: IOHandling, H6: IOHandling, H7: IOHandling, H8: IOHandling>(topLevelFunction: @escaping (StateType, IOContainer9<H0.IO, H1.IO, H2.IO, H3.IO, H4.IO, H5.IO, H6.IO, H7.IO, H8.IO>) -> (StateType, IOContainer9<H0.IO, H1.IO, H2.IO, H3.IO, H4.IO, H5.IO, H6.IO, H7.IO, H8.IO>)?,
                                                                                                                                                                                      initialState: StateType,
                                                                                                                                                                                      handlerTypes: (H0.Type, H1.Type, H2.Type, H3.Type, H4.Type, H5.Type, H6.Type, H7.Type, H8.Type)) -> Main {
        typealias IO = IOContainer9<H0.IO, H1.IO, H2.IO, H3.IO, H4.IO, H5.IO, H6.IO, H7.IO, H8.IO>
        let handlers = (H0(), H1(), H2(), H3(), H4(), H5(), H6(), H7(), H8())
        
        return .init(mainHelper: MainHelper(topLevelFunction: topLevelFunction,
                                            initialState: initialState,
                                            initialIO: .init()) { outputs, inp in
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs0, handler: handlers.0) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs1, handler: handlers.1) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs2, handler: handlers.2) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs3, handler: handlers.3) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs4, handler: handlers.4) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs5, handler: handlers.5) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs6, handler: handlers.6) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs7, handler: handlers.7) { inp(.create($0), $1) }
                                                MainHelper<StateType, IO>.process(outputs: outputs.outputs8, handler: handlers.8) { inp(.create($0), $1) }
        })
    }
}


public struct IOContainer9<T0: IOType, T1: IOType, T2: IOType, T3: IOType, T4: IOType, T5: IOType, T6: IOType, T7: IOType, T8: IOType>: IOContaining {
    
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
    
    public func input(forToken token: IOToken<T4>) -> T4.Input? {
        core.input(inputStorage: core.inputs.input4, token: token)
    }
    
    public func input(forToken token: IOToken<T5>) -> T5.Input? {
        core.input(inputStorage: core.inputs.input5, token: token)
    }
    
    public func input(forToken token: IOToken<T6>) -> T6.Input? {
        core.input(inputStorage: core.inputs.input6, token: token)
    }
    
    public func input(forToken token: IOToken<T7>) -> T7.Input? {
        core.input(inputStorage: core.inputs.input7, token: token)
    }
    
    public func input(forToken token: IOToken<T8>) -> T8.Input? {
        core.input(inputStorage: core.inputs.input8, token: token)
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
    
    public func addingOutput(_ output: T4.Output) -> (io: Self, token: IOToken<T4>) {
        core.updatingOutputs({ $0.copy(override4: $0.outputs4.adding((output, $1))) }) { .init(core: $0) }
    }
    
    public func addingOutput(_ output: T5.Output) -> (io: Self, token: IOToken<T5>) {
        core.updatingOutputs({ $0.copy(override5: $0.outputs5.adding((output, $1))) }) { .init(core: $0) }
    }
    
    public func addingOutput(_ output: T6.Output) -> (io: Self, token: IOToken<T6>) {
        core.updatingOutputs({ $0.copy(override6: $0.outputs6.adding((output, $1))) }) { .init(core: $0) }
    }
    
    public func addingOutput(_ output: T7.Output) -> (io: Self, token: IOToken<T7>) {
        core.updatingOutputs({ $0.copy(override7: $0.outputs7.adding((output, $1))) }) { .init(core: $0) }
    }
    
    public func addingOutput(_ output: T8.Output) -> (io: Self, token: IOToken<T8>) {
        core.updatingOutputs({ $0.copy(override8: $0.outputs8.adding((output, $1))) }) { .init(core: $0) }
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
        
        static func create(_ input: T4.Input?) -> Self {
            .init(input4: input)
        }
        
        static func create(_ input: T5.Input?) -> Self {
            .init(input5: input)
        }
        
        static func create(_ input: T6.Input?) -> Self {
            .init(input6: input)
        }
        
        static func create(_ input: T7.Input?) -> Self {
            .init(input7: input)
        }
        
        static func create(_ input: T8.Input?) -> Self {
            .init(input8: input)
        }
        
        fileprivate let input0: T0.Input?
        fileprivate let input1: T1.Input?
        fileprivate let input2: T2.Input?
        fileprivate let input3: T3.Input?
        fileprivate let input4: T4.Input?
        fileprivate let input5: T5.Input?
        fileprivate let input6: T6.Input?
        fileprivate let input7: T7.Input?
        fileprivate let input8: T8.Input?
        
        fileprivate init(input0: T0.Input? = nil,
                         input1: T1.Input? = nil,
                         input2: T2.Input? = nil,
                         input3: T3.Input? = nil,
                         input4: T4.Input? = nil,
                         input5: T5.Input? = nil,
                         input6: T6.Input? = nil,
                         input7: T7.Input? = nil,
                         input8: T8.Input? = nil) {
            self.input0 = input0
            self.input1 = input1
            self.input2 = input2
            self.input3 = input3
            self.input4 = input4
            self.input5 = input5
            self.input6 = input6
            self.input7 = input7
            self.input8 = input8
        }
    }
    
    struct Outputs: OutputsCreating {
        
        typealias OT<T: IOType> = (T.Output, IOToken<T>)
        
        let outputs0: [OT<T0>]
        let outputs1: [OT<T1>]
        let outputs2: [OT<T2>]
        let outputs3: [OT<T3>]
        let outputs4: [OT<T4>]
        let outputs5: [OT<T5>]
        let outputs6: [OT<T6>]
        let outputs7: [OT<T7>]
        let outputs8: [OT<T8>]
        
        static func create() -> Self {
            .init(outputs0: [],
                  outputs1: [],
                  outputs2: [],
                  outputs3: [],
                  outputs4: [],
                  outputs5: [],
                  outputs6: [],
                  outputs7: [],
                  outputs8: [])
        }
        
        fileprivate func copy(override0: [OT<T0>]? = nil,
                              override1: [OT<T1>]? = nil,
                              override2: [OT<T2>]? = nil,
                              override3: [OT<T3>]? = nil,
                              override4: [OT<T4>]? = nil,
                              override5: [OT<T5>]? = nil,
                              override6: [OT<T6>]? = nil,
                              override7: [OT<T7>]? = nil,
                              override8: [OT<T8>]? = nil) -> Self {
            .init(outputs0: override0 ?? outputs0,
                  outputs1: override1 ?? outputs1,
                  outputs2: override2 ?? outputs2,
                  outputs3: override3 ?? outputs3,
                  outputs4: override4 ?? outputs4,
                  outputs5: override5 ?? outputs5,
                  outputs6: override6 ?? outputs6,
                  outputs7: override7 ?? outputs7,
                  outputs8: override8 ?? outputs8)
        }
    }
    
    let core: IOContainerCore<Inputs, Outputs>
    
    init(core: IOContainerCore<Inputs, Outputs> = .init(inputTokenId: nil, inputs: Inputs(), outputs: .create())) {
        self.core = core
    }
}


