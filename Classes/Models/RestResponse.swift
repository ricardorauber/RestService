/// Response of the request with some useful methods
public struct RestResponse {
	
	/// Data returned from the request
	public let data: Data?
	
	/// Original request
	public let request: URLRequest?
	
	/// Original response
	public let response: URLResponse?
	
	/// Original error
	public let error: Error?
	
	// MARK: - Initialization
	
	/// Creates a new instance of the RestResponse
	///
	/// - Parameters:
	///   - data: Data returned from the request
	///   - request: Original request
	///   - response: Original response
	///   - error: Original error
	public init(data: Data?,
				request: URLRequest?,
				response: URLResponse?,
				error: Error?) {
		
		self.data = data
		self.request = request
		self.response = response
		self.error = error
	}
	
	// MARK: - Computed Properties
	
	/// Status code of the response
	public var statusCode: Int {
		guard let httpResponse = response as? HTTPURLResponse else { return -1 }
		return httpResponse.statusCode
	}
	
	/// Headers of the response
	public var headers: [AnyHashable: Any]? {
		guard let httpResponse = response as? HTTPURLResponse else { return nil }
		return httpResponse.allHeaderFields
	}
	
	// MARK: - Response Data Conversion
	
	/// Converts the data into a string
	///
	/// - Parameter encoding: String encoding
	public func stringValue(encoding: String.Encoding = .utf8) -> String? {
		guard let data = data else { return nil }
		return String(data: data, encoding: encoding)
	}
	
	/// Converts the data into an integer
	public func intValue() -> Int? {
		return Int(stringValue() ?? "")
	}
	
	/// Converts the data into a double
	public func doubleValue() -> Double? {
		return Double(stringValue() ?? "")
	}
	
	/// /// Converts the data into a decodable object
	///
	/// - Parameter type: Decodable type
	public func decodableValue<T: Decodable>(of type: T.Type) -> T? {
		guard let data = data else { return nil }
		return try? JSONDecoder().decode(type, from: data)
	}
	
	/// Converts the data into a dictionary
	public func dictionaryValue() -> [String: Any]? {
		guard let data = data else { return nil }
		return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
	}
	
	/// Converts the data into an array
	public func arrayValue() -> [Any]? {
		guard let data = data else { return nil }
		return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any]
	}
}
