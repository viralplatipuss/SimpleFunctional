import Foundation

/// IO Tokens are received when adding an output to an IO.
/// They can be passed into an IO to retrieve inputs.
public struct IOToken<T: IOType>: Hashable {
    
    /// Unique ID backing the token.
    let id: UInt
    
    init(id: UInt) {
        self.id = id
    }
}
