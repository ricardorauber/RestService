import Foundation

public enum RestTaskResultWithData<D: Codable> {
    
    case success(D)
    case failure(Error)
}

// MARK: - ResultConvertible
extension RestTaskResultWithData: ResultConvertible {

    public var result: Result<D, Error> {
        switch self {
        case .success(let data):
            return .success(data)
        case .failure(let error):
            return .failure(error)
        }
    }
}
