import Foundation

public struct HTTPScheme: RawRepresentable, Equatable, Hashable {
    
    // MARK: - Properties
	
	public typealias RawValue = String
	public let rawValue: String
	
	// MARK: - Initialization
	
	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}

// MARK: - Default values
public extension HTTPScheme {
	
	static let http = HTTPScheme(rawValue: "http")
	static let https = HTTPScheme(rawValue: "https")
}
