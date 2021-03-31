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

// MARK: - Static values
extension RestServiceError {
    public static let unknown = RestServiceError("Unknown")
}
