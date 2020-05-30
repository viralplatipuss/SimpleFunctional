import Foundation

public struct IOContainer1<T0: IOType>: IOContaining {
    
    // MARK: - Inputs
    
    public func input(forToken token: IOToken<T0>) -> T0.Input? {
        core.input(inputStorage: core.inputs.input0, token: token)
    }
    
    // MARK: - Outputs
    
    public func addingOutput(_ output: T0.Output) -> (io: Self, token: IOToken<T0>) {
        core.updatingOutputs({ $0.copy(override0: $0.outputs0.adding((output, $1))) }) { .init(core: $0) }
    }
    
    
    // MARK: - Internal
    
    struct Inputs {
        
        static func create(_ input: T0.Input?) -> Self {
            .init(input0: input)
        }
        
        fileprivate let input0: T0.Input?
        
        fileprivate init(input0: T0.Input? = nil) {
            self.input0 = input0
        }
    }
    
    struct Outputs: OutputsCreating {
        
        typealias OT<T: IOType> = (T.Output, IOToken<T>)
        
        let outputs0: [OT<T0>]
        
        static func create() -> Self {
            .init(outputs0: [])
        }
        
        fileprivate func copy(override0: [OT<T0>]? = nil) -> Self {
            .init(outputs0: override0 ?? outputs0)
        }
    }
    
    let core: IOContainerCore<Inputs, Outputs>
    
    init(core: IOContainerCore<Inputs, Outputs> = .init(inputTokenId: nil, inputs: Inputs(), outputs: .create())) {
        self.core = core
    }
}
