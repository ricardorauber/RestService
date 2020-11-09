import Foundation

public struct RestResponse {
    
    // MARK: - Properties
	
	public let data: Data?
	public let request: URLRequest?
	public let response: URLResponse?
	public let error: Error?
	
	// MARK: - Initialization
	
	public init(data: Data?,
				request: URLRequest?,
				response: URLResponse?,
				error: Error?) {
		
		self.data = data
		self.request = request
		self.response = response
		self.error = error
	}
}
	
// MARK: - Response Properties
extension RestResponse {
	
	public var statusCode: Int {
		guard let httpResponse = response as? HTTPURLResponse else { return -1 }
		return httpResponse.statusCode
	}
	
	public var headers: [AnyHashable: Any]? {
		guard let httpResponse = response as? HTTPURLResponse else { return nil }
		return httpResponse.allHeaderFields
	}
}
	
// MARK: - Response Data Conversion
extension RestResponse {
	
	public func stringValue(encoding: String.Encoding = .utf8) -> String? {
		guard let data = data else { return nil }
		return String(data: data, encoding: encoding)
	}
	
	public func intValue() -> Int? {
		return Int(stringValue() ?? "")
	}
	
	public func doubleValue() -> Double? {
		return Double(stringValue() ?? "")
	}
	
	public func decodableValue<T: Decodable>(of type: T.Type) -> T? {
		guard let data = data else { return nil }
		return try? JSONDecoder().decode(type, from: data)
	}
	
	public func dictionaryValue() -> [String: Any]? {
		guard let data = data else { return nil }
		return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
	}
	
	public func arrayValue() -> [Any]? {
		guard let data = data else { return nil }
		return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any]
	}
}
