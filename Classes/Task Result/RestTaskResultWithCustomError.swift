import Foundation

public enum RestTaskResultWithCustomError<E: Codable> {
    
    case success
    case failure
    case customError(E)
}
