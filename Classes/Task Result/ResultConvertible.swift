import Foundation

public protocol ResultConvertible {
    associatedtype T
    associatedtype E: Error
    
    func getResult() -> Result<T, E>
}
