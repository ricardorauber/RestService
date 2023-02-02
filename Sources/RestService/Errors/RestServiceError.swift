import Foundation

public struct RestServiceError: Error, LocalizedError {

    // MARK: - Properties

    public let error: String
    public var errorDescription: String? {
        error
    }
    
    // MARK: - Initialization
    
    public init(_ error: String) {
        self.error = error
    }
}

// MARK: - Equatable
extension RestServiceError: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.error == rhs.error
    }
}

// MARK: - Static values
extension RestServiceError {
    public static let unknown = RestServiceError("Unknown")
    public static let noData = RestServiceError("No data")
}
