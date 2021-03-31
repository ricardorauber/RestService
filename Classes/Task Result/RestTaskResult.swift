import Foundation

public enum RestTaskResult {
    
    case success
    case failure(Error)
}

// MARK: - ResultConvertible
extension RestTaskResult: ResultConvertible {

    public func getResult() -> Result<Void, Error> {
        switch self {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
