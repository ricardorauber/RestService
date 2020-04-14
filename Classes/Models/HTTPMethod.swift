/// HTTP method of the requests
public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
	
	public typealias RawValue = String
	public let rawValue: String
	
	// MARK: - Initialization
	
	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}

// MARK: - Default values
public extension HTTPMethod {
	
	static let connect = HTTPMethod(rawValue: "CONNECT")
	static let delete = HTTPMethod(rawValue: "DELETE")
	static let get = HTTPMethod(rawValue: "GET")
	static let head = HTTPMethod(rawValue: "HEAD")
	static let options = HTTPMethod(rawValue: "OPTIONS")
	static let post = HTTPMethod(rawValue: "POST")
	static let put = HTTPMethod(rawValue: "PUT")
	static let trace = HTTPMethod(rawValue: "TRACE")
}
