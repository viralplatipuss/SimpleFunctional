import Foundation

struct IOContainerCore<Inputs, Outputs: OutputsCreating> {
    
    let inputTokenId: UInt?
    let inputs: Inputs
    let outputs: Outputs
    
    init(nextId: UInt = 0,
         inputTokenId: UInt?,
         inputs: Inputs,
         outputs: Outputs) {
        self.nextId = nextId
        self.inputTokenId = inputTokenId
        self.inputs = inputs
        self.outputs = outputs
    }
    
    func input<T: IOType>(inputStorage: T.Input?, token: IOToken<T>) -> T.Input? {
        guard token.id == inputTokenId, let input = inputStorage else { return nil }
        return input
    }
    
    func updatingOutputs<T: IOType, C>(_ outputClosure: (Outputs, IOToken<T>) -> Outputs, map: (Self) -> C) -> (io: C, token: IOToken<T>) {
        let token = IOToken<T>(id: nextId)
        let newCore = Self(nextId: nextId + 1, inputTokenId: inputTokenId, inputs: inputs, outputs: outputClosure(outputs, token))
        
        return (map(newCore), token)
    }
    
    func copyClearingOutputs(inputs: Inputs, inputTokenId: UInt) -> Self {
        .init(nextId: nextId, inputTokenId: inputTokenId, inputs: inputs, outputs: .create())
    }
    
    
    // MARK: - Private
    
    private let nextId: UInt
}
