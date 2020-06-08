# SimpleFunctional

A simple framework for building pure functional apps in Swift.

The framework is designed to make software very simple and easy to reason about by completely detaching IO events and other side-effects from pure logic. It assumes you have an understanding of pure functional code, and the importance of decoupling IO and side-effects.

Rather than using Rx/Combine patterns, the app is simply an immutable value type with a single run function, that takes an input, and returns a new app state and any desired outputs.

Input-Outputs for your application can be handled by creating IO Handlers.

Every time your pure function runs, the IO Handlers (messy, stateful, imperative code that lives outside of your pure functional world) process the outputs. When one of those outputs produces an input, the function is run again with that input. Other inputs, if any, are queued up to be synchronously run after.

If the function does not request any outputs for the previous input, and no previous outputs are processing, the application ends, as you'd expect from a typical main function.

**This is a very simple back-to-basics approach to writing functional software. This library doesn't provide any architecture for your app itself, but a simple framework so that most of your app's code can be pure functional. Obviously a lot more work is required to achieve even basic functionality that comes with a lot of existing Apple libraries. Mainly by wrapping everything you want to use in an IOHandler to provide it in a functional way. However, I am attempting to use this approach to develop complex software and will open source generalized IOHandlers as I create them.**

## Examples

Check out the [SimpleFunctional Weather app](https://github.com/viralplatipuss/SimpleFunctionalWeather/), it's terrible, but it'll show you the library in action.

There is also an **Example.swift** file in this package.

## Usage

### Installation
SimpleFunctional is a Swift package. Use your preferred package manager.
I like to use Xcode's built-in tool under **File > Swift Packages**
Or you can add the dependency directly to your **Package.swift**
```swift
.package(url: "https://github.com/viralplatipuss/SimpleFunctional.git", .exact("0.0.6"))
```

### Set Up

See **Example.swift**

First, you want to define (or use existing) IO types that your application needs to function.

You can do this by creating new IO structs that conform to the IO protocol. 
These should be immutable, functionally pure value types. Any sub-types should also be the same. 

For example, a console IO type, so the app can request to print messages to the console, with an input for when a message is printed:

```swift
struct ConsoleIO: IO {
    enum Input {
        case didPrint(message: String)
    }
    
    enum Output {
        case print(message: String)
    }
}
```

To actually handle this IO type, we need to create an IO Handler. Impreative, impure code, that lives outside of our application. These can and usually should be reference types / classes.

```swift
final class ConsoleIOHandler: IOHandling {
    typealias IOType = ConsoleIO
    
    func handle(output: IOType.Output, inputClosure: @escaping (IOType.Input) -> Void) {
        switch output {
        case .print(let message):
            print(message)
            inputClosure(.didPrint(message: message))
        }
    }
}
```

Imperative code is a liability, but necessary evil. The less your handlers do, the more you can handle in your pure function, in a safer (and potentially cross-platform) way!


If you have more than one IO type/handler, you'll want to make an IO type and handler for the App itself:

```swift

struct AppIO: IO {
    
    typealias IOA = ConsoleIO
    typealias IOB = ExampleIO
    
    typealias Input = IO<IOA.Input, IOB.Input>
    typealias Output = IO<IOA.Output, IOB.Output>
    
    enum IO<A, B> {
        case console(A)
        case example(B)
    }
}

final class AppIOHandler: IOHandling {
    typealias IOType = AppIO
    
    func handle(output: IOType.Output, inputClosure: @escaping (IOType.Input) -> Void) {
        switch output {
        case .console(let o): return consoleHandler.handle(output: o, inputClosure: { inputClosure(.console($0)) })
        case .example(let o): return exampleHandler.handle(output: o, inputClosure: { inputClosure(.example($0)) })
        }
    }
    
    private let consoleHandler = ConsoleIOHandler()
    private let exampleHandler = ExampleIOHandler()
}
```

These wrap the other types and handlers, so they're accessible through a single interface, as the ImpureApp class only handles one IO type and handler for the app.

Now, we want to create our functionally pure app itself! In this case, it's a very simple "Hello World" application:

```swift
struct App: PureAppProviding {
    
    typealias Input = AppIO.Input
    typealias Output = AppIO.Output
    
    func run(input: Input?) -> (app: Self, outputs: [Output])? {
        guard let _ = input else {
            return (self, [.console(.print(message: "Hello World!"))])
        }
        
        return nil
    }
}
```

Your app should also be an immutable value-type. 
This one checks for an input (as only the very first run of the app function will have a nil input), and if no input is found, request hello world be printed to the console.
It does not update the state of the app, but usually would. See the [weather app](https://github.com/viralplatipuss/SimpleFunctionalWeather/) for a better example. 

You want your run function to process the current state and possible input, and return any desired outputs **as fast as possible**. This function is the basis of your application and will be run, sychronously, every time there is a new input.
It should not do any async operations, handle timing, or block the thread it's running on in any way.

However, one of the biggest benefits to writing pure functional code with immutable value types only is that it makes multi-threading incredibly easy and safe. To take advantage of that, I would create an AsyncIO type that can run a pure functional closure on a background thread within an IO Handler. The result being passed back to the top-level function as an input. The closure can happily capture any state from within the run function, as it's all immutable and thread-safe!

An example could be a game, where the run function updates the world state and adds it to the IO as a rendering output. Then an IO Handler can render it to the screen on a different thread, while the run function could already be running again to process the next world state, as both threads can use the previous world state at the same time.


Finally, we need to create the **ImpureApp**. This is the top level class for your application, that runs your pure app, but also handles the imperative IO code.
This should be created and started as early as possible. Usually in **AppDelegate.swift** or ***main.swift** in cases like Vapor apps. 
You'll want to hold a strong reference to the **impureApp** for the duration of the application's lifecycle.
Call **start()** to begin the app.

```swift
class AppDelegate {

    let impureApp = ImpureApp(pureApp: App(), ioHandler: AppIOHandler())
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        impureApp.start()
        return true
    }
}
```

And that's it. Now you can start building out your pure functional app!


## Q&A

#### This is pretty simplistic, how am I supposed to build complicated applications out of this?

- It is really simplistic. That's the point. The architecture you use inside your pure function is up to you to figure out.

#### Why would I want to use this framework?

- You're a crazy person who enjoys building everything from scratch in the hardest way possible.
- Because pure functional code is the best.
- It's incredibly easy to step through the function and debug / reason about. All the state and inputs are there. It's pure logic with no sense of time, no race conditions, no streams (you ever tried to debug Rx?).
- It only uses foundational Swift code, so it is platform agnostic! Assuming you have IO Handlers for each platform, your logic can easily be used anywhere that can run foundational Swift.
- It's trivial to cache the prior app states for even more debugging help (given they should all be immutable value types, with the function generating a new one every call).

#### Why would I NOT want to use this framework?

- Because right now there are basically no IO handlers, so you'd have to create every single I/O from scratch. (Though I don't know how that doesn't sound like fun, you get to design the whole API)
- Because you're actually trying to build software that has to be released within the next 10 years.
- Because you love classes and mutable state and think that logic should just mix in with IO whenever it feels like.

#### What about multi-threading, if the app has just one run function that executes synchronously?

- See the discussion above in the **Set Up** section.

#### Are you going to create a load of default IO Handlers?

- Maybe. I'll probably wrap some basic stuff for my own needs and will share them. Wrapping all of UIKit would be too crazy, even for me.
