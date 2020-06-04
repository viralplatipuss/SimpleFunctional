import Foundation

public struct CodeGen {
    
    /// Use this to generate the code needed to support any number of IO Handlers!
    static func generateCodeForFactoryFunctionAndIOContainer(numberOfHandlers: UInt) -> String {
        guard numberOfHandlers > 0 else { return "" }
        
        let handlerNums = (0..<numberOfHandlers)
        
        func handlers(suffix: String) -> String {
            handlerNums.map { "H\($0)\(suffix)" }.joined(separator: ", ")
        }
        
        let containerGenerics = "IOContainer\(numberOfHandlers)<\(handlers(suffix: ".IO"))>"
        
        let proccessing = handlerNums.map { "MainHelper<StateType, IO>.process(outputs: outputs.outputs\($0), handler: handlers.\($0)) { inp(.create($0), $1) }" }.joined(separator: "\n")
        
        let factory = """
        import Foundation
        
        public extension MainFactory {
            static func createMain<StateType, \(handlers(suffix: ": IOHandling"))>(topLevelFunction: @escaping (StateType, \(containerGenerics)) -> (StateType, \(containerGenerics))?,
                                                                                                     initialState: StateType,
                                                                                                     handlerTypes: (\(handlers(suffix: ".Type")))) -> Main {
                typealias IO = \(containerGenerics)
                let handlers = (\(handlers(suffix: "()")))
                
                return .init(mainHelper: MainHelper(topLevelFunction: topLevelFunction,
                                                    initialState: initialState,
                                                    initialIO: .init()) { outputs, inp in
                                                        \(proccessing)
                })
            }
        }
        
        \(generateCodeForIOContainer(numberOfHandlers: numberOfHandlers))
        
        """
        
        return factory
        
    }
    
    private static func generateCodeForIOContainer(numberOfHandlers: UInt) -> String {
        
        let handlerNums = (0..<numberOfHandlers)
        
        let generics = handlerNums.map { "T\($0): IOType" }.joined(separator: ", ")
        
        let inputFuncs = handlerNums.map {
        """
            public func input(forToken token: IOToken<T\($0)>) -> T\($0).Input? {
            core.input(inputStorage: core.inputs.input\($0), token: token)
            }
        """ }.joined(separator: "\n\n")
        
        let outputFuncs = handlerNums.map {
        """
        public func addingOutput(_ output: T\($0).Output) -> (io: Self, token: IOToken<T\($0)>) {
            core.updatingOutputs({ $0.copy(override\($0): $0.outputs\($0).adding((output, $1))) }) { .init(core: $0) }
            }
        """ }.joined(separator: "\n\n")
        
        let inputCreate = handlerNums.map {
        """
            static func create(_ input: T\($0).Input?) -> Self {
                .init(input\($0): input)
            }
        """
        }.joined(separator: "\n\n")
        
        let inputProperties = handlerNums.map { "fileprivate let input\($0): T\($0).Input?" }.joined(separator: "\n")
        
        let inputInitParams = handlerNums.map { "input\($0): T\($0).Input? = nil" }.joined(separator: ",\n")
        
        let inputInitBody = handlerNums.map { "self.input\($0) = input\($0)" }.joined(separator: "\n")
        
        let outputProperties = handlerNums.map { "let outputs\($0): [OT<T\($0)>]" }.joined(separator: "\n")
        
        let outputInit = handlerNums.map { "outputs\($0): []" }.joined(separator: ",\n")
        
        let outputOverrideParams = handlerNums.map { "override\($0): [OT<T\($0)>]? = nil" }.joined(separator: ",\n")
        
        let outputOverrideBody = handlerNums.map { "outputs\($0): override\($0) ?? outputs\($0)" }.joined(separator: ",\n")
        
        return """

        public struct IOContainer\(numberOfHandlers)<\(generics)>: IOContaining {
            
            // MARK: - Inputs
            
            \(inputFuncs)
            
            // MARK: - Outputs
            
            \(outputFuncs)
            
        
            // MARK: - Internal
            
            struct Inputs {
                
                \(inputCreate)
                
                \(inputProperties)
                
                fileprivate init(\(inputInitParams)) {
                    \(inputInitBody)
                }
            }
            
            struct Outputs: OutputsCreating {
                
                typealias OT<T: IOType> = (T.Output, IOToken<T>)
                
                \(outputProperties)
                
                static func create() -> Self {
                    .init(\(outputInit))
                }
                
                fileprivate func copy(\(outputOverrideParams)) -> Self {
                    .init(\(outputOverrideBody))
                }
            }
            
            let core: IOContainerCore<Inputs, Outputs>
            
            init(core: IOContainerCore<Inputs, Outputs> = .init(inputTokenId: nil, inputs: Inputs(), outputs: .create())) {
                self.core = core
            }
        }

        """
    }
}
