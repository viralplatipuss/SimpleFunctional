import Foundation

/// IO Tokens are received when adding an output to an IO.
/// They can be passed into an IO to retrieve inputs.
/// Each token is unique due to the underlying id, set by the IO struct that creates it.
/// The tokens can be compared / used as keys due to be being Hashable and therefore Equatable.
/// Typically you want to store tokens in your state, so that you can retrieve the correlated input in a future top-level function call.
/// IOHandlers also have access to tokens and their associated outputs in their handle function. They can store and use the tokens to identify future outputs.
public struct IOToken<T: IOType>: Hashable {
    
    /// Unique ID backing the token.
    let id: UInt
    
    init(id: UInt) {
        self.id = id
    }
}
