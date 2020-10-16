import Foundation

/// An impure class that runs the pure app and handles IO.
/// This is the top-level class that runs your entire functional program.
/// It should be created as early as possible and then start() called, to begin the functional app.
/// This should be kept alive at the top-level of your program.
public final class ImpureApp<AppType: PureAppProviding, IOHandlerType: IOHandling> where IOHandlerType.IOType == AppType.IOType {
    
    /// The closure type for running an input. Needed by IOHandlers.
    public typealias RunInputClosure = (AppType.Input) -> Void
    
    /// Creates the impure app with a starting pure app state, and a function for building an ioHandler to deal with input-output.
    /// The ioHandler will be created from the builder during this init.
    public init(pureAppType: AppType.Type, ioHandlerBuilder: (@escaping RunInputClosure) -> IOHandlerType) {
        ioHandler = ioHandlerBuilder({ [weak self] in self?.run(input: $0) })
    }
    
    /// Starts the app.
    /// From here, the app will be re-run whenever there is a new input, as long as this class is kept alive.
    public func start() {
        guard !didStart else { return }
        didStart = true
        
        appQueue.async { [weak self] in
            guard let self = self else { return }
            
            let (app, outputs) = AppType.start()
            self.pureApp = app
            self.processOutputs(outputs)
        }
    }
    
    
    // MARK: - Private

    private var didStart = false
    private var pureApp: AppType? = nil
    private var ioHandler: IOHandlerType?
    
    private let appQueue = DispatchQueue(label: "ImpureApp.appQueue", qos: .userInteractive)
    private let ioQueue = DispatchQueue(label: "ImpureApp.ioQueue", qos: .userInitiated, attributes: .concurrent)

    private func run(input: AppType.Input) {
        appQueue.async { [weak self] in
            guard let self = self, let (app, outputs) = self.pureApp?.run(input: input) else { return }
            
            self.pureApp = app
            self.processOutputs(outputs)
        }
    }
    
    private func processOutputs(_ outputs: [AppType.Output]) {
        ioQueue.async {
            outputs.forEach { [weak self] in
                self?.ioHandler?.handle(output: $0)
            }
        }
    }
}
