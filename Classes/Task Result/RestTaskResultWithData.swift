import Foundation

public enum RestTaskResultWithData<D: Codable> {
    
    case success(D)
    case failure
}
