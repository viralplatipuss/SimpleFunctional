import Foundation

protocol MainHelping {
    func start()
}

final class MainHelper<StateType, IO: IOContaining>: MainHelping {
    
    typealias ProcessFunctionType = (IO.Outputs, (IO.Inputs, UInt) -> Void) -> Void
    
    init(topLevelFunction: @escaping (StateType, IO) -> (StateType, IO),
         initialState: StateType,
         initialIO: IO,
         processFunction: @escaping ProcessFunctionType) {
        self.topLevelFunction = topLevelFunction
        self.processFunction = processFunction
        self.state = initialState
        io = initialIO
    }
    
    func start() {
        guard !didStart else { return }
        didStart = true
        
        mainQueue.async { [weak self] in
            self?.run()
        }
    }
    
    static func process<T: IOHandling>(outputs: [(T.IO.Output, IOToken<T.IO>)], handler: T, inputAndTokenIdClosure: (T.IO.Input, UInt) -> Void) {
        outputs.forEach { [weak handler] (output, token) in
            handler?.handle(output: output, token: token) { inputAndTokenIdClosure($0, token.id) }
        }
    }
    
    
    // MARK: - Private
    
    private let mainQueue = DispatchQueue(label: "main", qos: .userInteractive)
    private let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
    
    private let topLevelFunction: (StateType, IO) -> (StateType, IO)
    private let processFunction: ProcessFunctionType
    
    private var didStart = false
    private var io: IO
    private var state: StateType
    
    private func run() {
        let result = topLevelFunction(state, io)
        state = result.0
        io = result.1
        
        processResultIO(result.1)
    }
    
    private func processResultIO(_ resultIO: IO) {
        concurrentQueue.async { [weak self] in
            self?.processFunction(resultIO.core.outputs) { [weak self] inputs, tokenId in
                self?.mainQueue.async { [weak self] in
                    guard let self = self else { return }
                    self.io = .init(core: self.io.core.copyClearingOutputs(inputs: inputs, inputTokenId: tokenId))
                    self.run()
                }
            }
        }
    }
}
