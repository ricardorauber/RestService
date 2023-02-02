import Foundation

public enum RestTaskResultWithDataAndCustomError<D: Codable, E: Codable & Error> {
    
    case success(D)
    case failure(Error)
    case customError(E)
}

// MARK: - ResultConvertible
extension RestTaskResultWithDataAndCustomError: ResultConvertible {

    public var result: Result<D, Error> {
        switch self {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        case .customError(let error):
            return .failure(error)
        }
    }
}
