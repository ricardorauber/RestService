import Foundation

public enum RestTaskResultWithDataAndCustomError<D: Codable, E: Codable> {
    
    case success(D)
    case failure
    case customError(E)
}
