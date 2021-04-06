import Foundation

public protocol ResultConvertible {
    associatedtype T
    associatedtype E: Error
    
    var result: Result<T, E> { get }
}
