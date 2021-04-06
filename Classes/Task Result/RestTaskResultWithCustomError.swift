import Foundation

public enum RestTaskResultWithCustomError<E: Codable & Error> {
    
    case success
    case failure(Error)
    case customError(E)
}

// MARK: - ResultConvertible
extension RestTaskResultWithCustomError: ResultConvertible {
    
    public var result: Result<Void, Error> {
        switch self {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        case .customError(let error):
            return .failure(error)
        }
    }
}
