# SimpleFunctional

A simple framework for building pure functional apps in Swift.

The framework is designed to make software very simple and easy to reason about by completely detaching IO events and other side-effects from pure logic. It assumes you have an understanding of pure functional code, and the importance of decoupling IO and side-effects.

Rather than using Rx/Combine patterns, the app is simply a single function that takes a state and inputs, and returns a new state and desired outputs. (Inputs and Outputs are both managed by the same IO struct).

Every Input-Output situation can be handled by creating IO Handlers. The types for each of these can be provided to the MainFactory, which will automatically make their inputs and outputs accessible from within your pure function, at compile-time. Full compile-time safety and concrete types!

Right now, SimpleFunctional supports up to 10 different IO Handlers. If you need more, simply use the **CodeGen.swift** file included in Utils to generate support for any number of handlers.

Every time your pure function runs, the IO Handlers (messy, stateful, imperative code that lives outside of your pure functional world) process the outputs. When one of those outputs produces an input, the function is run again with that input. Other inputs, if any, are queued up to be synchronously run after.

If the function does not request any outputs for the previous input, and no previous outputs are processing, the application ends, as you'd expect from a typical main function.

**This is a very simple back-to-basics approach to writing functional software. This library doesn't provide any architecture for your app itself, but a framework so that most of your app's code can be pure functional. Obviously a lot more work is required to achieve even basic functionality that comes with a lot of existing Apple libraries. Mainly by wrapping everything you want to use in an IOHandler to provide it in a functional way. However, I am attempting to use this approach to develop complex software and will open source generalized IOHandlers as I create them.**

## Examples

Check out the [SimpleFunctional Weather app](https://github.com/viralplatipuss/SimpleFunctionalWeather/), it's terrible, but it'll show you the library in action.

## Usage

### Installation
SimpleFunctional is a typical Swift package. Use your preferred package manager.
I personally like to use Xcode's built-in tool under **File > Swift Packages**
Or you can add the dependency directly to your **Package.swift**
```swift
.package(url: "https://github.com/viralplatipuss/SimpleFunctional.git", .exact("0.0.4"))
```

### Set Up

I recommend you first create an **AppConfig.swift** file, which will specify all your IOHandlers and a function to create your Main class:

```swift
import Foundation
import SimpleFunctional

/// Convenience alias for the app's IO container type.
typealias IO = MainFactory.IO

/**
 MainFactory extension containing all the needed configuration for our App.
 To add a new handler: add a typealias, increment the IOContainer number and add the handler to the generics, add the type to handlerTypes. That's it! It'll be available to use with compile-time typing in your topLevelFunction.
*/
extension MainFactory {
    typealias Handler0 = ViewIOHandler
    typealias Handler1 = HTTPIOHandler
    typealias Handler2 = TimerIOHandler
    
    typealias IO = IOContainer3<Handler0.IO, Handler1.IO, Handler2.IO>
    
    private static let handlerTypes = (Handler0.self, Handler1.self, Handler2.self)
    
    static func createMain() -> Main {
    // App is a struct that has a run function on it, which takes IO.
    // It is the main entry point for my pure code and is completely immutable and functionally pure.
        let topLevelFunc: (App, IO) -> (App, IO) = { $0.run(io: $1) }
        return Self.createMain(topLevelFunction: topLevelFunc, initialState: .init(), handlerTypes: handlerTypes)
    }
}
```

You'll want to drop into the pure-functional world at the earliest possible point in your App's lifecycle. This could be AppDelegate/SceneDelegate, if it's an App with UI. Or Main.swift for server code like Vapor.

Here's a typical set up:

```swift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let main = MainFactory.createMain()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        
        // Start our functional app!
        main.start()
    }
```

Finally, we can create the top-level function and the state that it transforms. This is the starting point of our pure functional app. 

The state should be a struct, with all immutable properties. I typically like to create an App struct and add a function directly to it to serve as our top-level function. Which will return a new copy of itself. A more Swifty style approach to functional code.

```swift
struct App {
    
    func run(io: IO) -> (self: Self, io: IO)? {
        // Our top-level function. 
        // It takes a state (self) and IO, and returns an updated copy of that state, and an updated IO.
    }
    
    private let someState: SomeStateType
```

IO is a typealias for the IOContainerX struct, where X is the number of Handlers it manages.
It has built-in, typed functions for returning a new copy of itself by adding outputs.
It also has typed functions for getting input.

**Note: An IO struct can contain multiple outputs, but only ever a single input. This is because the top-level function should be run again for every input received, in the order they are received.**

You want your top-level function to process the state and possible input, and return any desired outputs **as fast as it can**.
This function is the basis of your application and will be run, sychronously, every time there is a new input.

It should not do any async operations, handle timing, or block the thread it's running on.

However, one of the biggest benefits to writing pure functional code with immutable state is that it makes multi-threading incredibly easy and safe. To take advantage of that, I would create an AsyncIO type that can run a pure functional closure on a background thread within an IO Handler. The result being passed back to the top-level function as an input. The closure can happily capture any state from within the top-level function, as it's all immutable and thread-safe!

An example could be a game, where the top-level function updates the world state and adds it to the IO as a rendering output. Then an IO Hanlder can render it to the screen in a different thread, while the top-level function could already be running again to process the next world state, as both threads can use the previous world state at the same time.


### Creating IO types

To create your own IO types and handlers, see the IOProtocols.swift file.

```swift
/// Represents a type of IO. Each IO type should inherit this protocol and define its own input and output structs.
public protocol IOType {
    
    associatedtype Input
    
    associatedtype Output
}

/// IO handlers confrom to this protocol in order to handle incoming outputs and return inputs.
public protocol IOHandling: class {
    
    /// The type of IO this handler handles.
    associatedtype IO: IOType
    
    /// Implement to handle an output and generate an input, if needed.
    func handle(output: IO.Output, token: IOToken<IO>, inputClosure: @escaping (IO.Input) -> Void)
    
    /// Create the handler.
    init()
}
```

First, you need to define a struct that conforms to IOType. It should provide the types for Input and Output. This struct and sub-types within it should have no mutable state.

Here's an example one for a simple TimerIO, that allows your pure function to output a request for a timer. When the timer fires, the pure function will be called with a timerFired input:

```swift

/// Pure functional IO struct.
struct TimerIO: IOType {
    enum Input {
        case timerFired
    }
    
    enum Output {
        case addTimer(milliseconds: UInt)
    }
}

/// Ugly, imperative IO Handler class.
final class TimerIOHandler: IOHandling {
    
    typealias IO = TimerIO
    
    func handle(output: IO.Output, token: IOToken<IO>, inputClosure: @escaping (IO.Input) -> Void) {
        guard case let IO.Output.addTimer(milliseconds) = output else { return }
        
        queue.asyncAfter(deadline: .now() + .milliseconds(Int(milliseconds))) {
            inputClosure(.timerFired)
        }
    }
    
    private let queue = DispatchQueue(label: "TimerIOHandler.queue", attributes: .concurrent)
}


```

Imperative code is a liability, but necessary evil. The less your handlers do, the more you can handle in your pure function, in a safer (and possibly cross-platform) way. 

## Q&A

#### This is pretty simplistic, how am I supposed to build complicated applications out of this?

- It is really simplistic. That's the point. The architecture you use inside your pure function is up to you to figure out.

#### Why would I want to use this framework?

- You're a crazy person who enjoys building everything from scratch in the hardest way possible.
- Because pure functional code is the best.
- It's incredibly easy to step through the function and debug / reason about. All the state and inputs are there. It's pure logic with no sense of time, no race conditions, no streams (you ever tried to debug Rx?).
- It only uses foundational Swift code, so it is platform agnostic! Assuming you have IO Handlers for each platform, your logic can easily be used anywhere that can run foundational Swift.
- It's trivial to cache the prior states from each function call for even more debugging help (given they should all be immutable structs, with the function generating a new one every call).

#### Why would I NOT want to use this framework?

- Because right now there are basically no IO handlers, so you'd have to create every single I/O from scratch. (Though I don't know how that doesn't sound like fun, you get to design the whole API)
- Because you're actually trying to build software that has to be released within the next 10 years.
- Because you love classes and mutable state and think that logic should just mix in with IO whenever it feels like.

#### What about multi-threading, if it's just one function that runs synchronously?

- See the discussion above in the **Set Up** section.

#### Are you going to create a load of default IO Handlers?

- Maybe. I'll probably wrap some basic stuff for my own needs and will share them. Wrapping all of UIKit would be too crazy, even for me.
