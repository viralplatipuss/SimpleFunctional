import Foundation

public final class ImpureApp<AppType: PureAppProviding, IOHandlerType: IOHandling> where AppType.Input == IOHandlerType.IOType.Input, AppType.Output == IOHandlerType.IOType.Output {
    
    /// Creates the impure app with a starting pure app state, and an ioHandler to deal with input-output.
    public init(pureApp: AppType, ioHandler: IOHandlerType) {
        self.ioHandler = ioHandler
        self.pureApp = pureApp
    }
    
    /// Starts the app.
    /// From here, the app will be re-run internally whenever there is a new input.
    public func start() {
        guard !didStart else { return }
        didStart = true
        run(input: nil)
    }
    
    
    // MARK: - Private
    
    private var pureApp: AppType
    private let ioHandler: IOHandlerType
    private let appQueue = DispatchQueue(label: "ImpureApp.appQueue")
    private let ioQueue = DispatchQueue(label: "ImpureApp.ioQueue", attributes: .concurrent)
    private var didStart = false
    
    private func run(input: AppType.Input?) {
        appQueue.async { [weak self] in
            guard let (app, outputs) = self?.pureApp.run(input: input) else { return }
            self?.pureApp = app
            
            self?.processOutputs(outputs)
        }
    }
    
    private func processOutputs(_ outputs: [AppType.Output]) {
        ioQueue.async { [weak self] in
            outputs.forEach { [weak self] in
                self?.processOutput($0)
            }
        }
    }
    
    private func processOutput(_ output: AppType.Output) {
        ioQueue.async { [weak self] in
            self?.ioHandler.handle(output: output) { [weak self] in
                self?.run(input: $0)
            }
        }
    }
}
