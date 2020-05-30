# SimpleFunctional

A simple framework for building pure functional apps in Swift.

The framework is designed to make software very simple and easy to reason about by completely detaching IO events and other side-effects from pure logic. 

Rather than using Rx/Combine patterns, the app is simply a single function that takes a state and IO, and returns a new state and IO (with desired outputs added).

Every Input-Output situation can be handled by creating IO Handlers. The types for each of these can be provided to the MainFactory, which will automatically make their inputs and outputs accessible from within your pure function, at compile-time. Full compile-time safety and concrete types!

Right now, SimpleFunctional supports up to 10 different IO Handlers. If you need more, simply use the CodeGen.swift file included in Utils to generate support for any number of handlers.

Every time your pure function runs, the IO Handlers (messy, stateful, imperative code that lives outside of your pure functional world) process the outputs. When one of those outputs produces an input, the function is run again with that input. Other inputs, if any, are queued up to be synchronously run after.

If the function does not request any outputs for the previous input, and no previous outputs are processing, the application ends, as you'd expect from a typical main function.


## Usage

TBD.


## Q&A

This sounds pretty simplistic, how am I supposed to build complicated applications out of this?

- It is really simplistic. That's the point. The architecture you use inside your pure function is up to you to figure out.


Why would I want to use this framework?

- You're a crazy person who enjoys building everything from scratch in the hardest way possible.

- Because pure functional code is the best.

- It's incredibly easy to step through the function and debug / reason about. All the state and inputs are there. It's pure logic with no sense of time, no race conditions, no streams (you ever tried to debug Rx?).

- It only uses foundational Swift code, so it is platform agnostic! Assuming you have IO Handlers for each platform, your logic can easily be used anywhere.

- It's trivial to cache the prior states from each function call for even more debugging help (given they should all be structs, with the function generating a new one every call).


Why would I NOT want to use this framework?

- Because right now there are basically no IO handlers, so you'd have to create every single I/O from scratch. (Though I don't know how that doesn't sound like fun, you get to design the whole API)

- Because you're actually trying to build software that has to be released within the next 10 years.

- Because you love classes and mutable state and think that logic should just mix in with IO whenever it feels like.


Are you going to create a load of default IO Handlers?

- Maybe. I'll probably wrap some basic stuff for my own needs and will share them. Wrapping all of UIKit would be too crazy, even for me. But I did have plans to design an IO system where the function can request a view controller be built (as an output) and then request changes to that exisiting view controller as needed. A sort of functional UIKit that's more than just directly drawing to a screen.  
