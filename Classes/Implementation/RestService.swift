/// A REST service object that can make requests to a server.
public class RestService {
	
	/// URLSession instance for this service
	public let session: URLSession
	
	/// Scheme of the server URI
	public var scheme: HTTPScheme
	
	/// Host of the server URI
	public var host: String
	
	// Port of the server URI
	public var port: Int?
	
	/// Defines if the tasks should be executed automatically or not
	public var resumeTasksAutomatically = true
	
	// MARK: - Initialization
	
	/// Creates a new instance of the RestService
	///
	/// - Parameters:
	///   - session: URLSession instance for this service
	///   - scheme: Scheme of the server URI
	///   - host: Host of the server URI
	///   - port: Port of the server URI
	public init(session: URLSession = URLSession.shared,
				scheme: HTTPScheme = .https,
				host: String,
				port: Int? = nil) {
		
		self.session = session
		self.scheme = scheme
		self.host = host
		self.port = port
	}
	
	// MARK: - Request building
	
	/// Builds a list of query items from a given codable object
	///
	/// - Parameter parameters: Codable object with the parameters
	func buildQueryItems<T: Codable>(parameters: T) -> [URLQueryItem] {
		guard let encoded = try? JSONEncoder().encode(parameters),
			let decoded = try? JSONSerialization.jsonObject(with: encoded, options: .mutableContainers) as? [String: Any]
			else {
				return []
		}
		return buildQueryItems(parameters: decoded)
	}
	
	/// Builds a list of query items from a given dictionary
	///
	/// - Parameter parameters: Dictionary with the parameters
	func buildQueryItems(parameters: [String: Any]) -> [URLQueryItem] {
		var queryItems: [URLQueryItem] = []
		for (key, value) in parameters {
			if let items = value as? [Any] {
				for item in items {
					queryItems.append(URLQueryItem(name: key, value: String(describing: item)))
				}
			} else {
				queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
			}
		}
		return queryItems
	}
	
	/// Generates all headers needed for JSON requests
	func jsonHeaders() -> [String: String] {
		return [
			"Content-Type": "application/json; charset=utf-8"
		]
	}
	
	/// Generates all headers needed for Form Data requests
	func formDataHeaders(boundary: String) -> [String: String] {
		return [
			"Content-Type": "multipart/form-data; boundary=" + boundary
		]
	}
	
	/// Builds the JSON body from a given codable object
	///
	/// - Parameter parameters: Codable object with the parameters
	func buildJsonBody<T: Codable>(parameters: T) -> Data? {
		return try? JSONEncoder().encode(parameters)
	}
	
	/// Builds the JSON body from a given dictionary
	///
	/// - Parameter parameters: Dictionary with the parameters
	func buildJsonBody(parameters: [String: Any]) -> Data? {
		return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
	}
	
	/// Builds the Form Data body from a given list of parameters
	/// - Parameters:
	///   - boundary: Identifier of the parts of the request
	///   - parameters: List of parameters
	func buildFormDataBody(boundary: String, parameters: [FormDataParameter]) -> Data? {
		guard !boundary.isEmpty, parameters.count > 0 else { return nil }
		var data = Data()
		for parameter in parameters {
			if let formData = parameter.formData(boundary: boundary) {
				data.append(formData)
			}
		}
		if let formData = "--\(boundary)--\r\n".data(using: .utf8) {
			data.append(formData)
		}
		return data
	}
	
	/// Builds the request to be executed
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - queryItems: List of items for the query
	///   - headers: List of headers
	///   - body: Data body
	///   - interceptor: Adapts the request after creation
	func buildRequest(method: HTTPMethod,
					  path: String,
					  queryItems: [URLQueryItem]?,
					  headers: [String: String]?,
					  body: Data?,
					  interceptor: RestRequestInterceptor?) -> URLRequest? {
		
		var urlComponents = URLComponents()
		urlComponents.scheme = scheme.rawValue
		urlComponents.host = host
		urlComponents.port = port
		urlComponents.path = path
		urlComponents.queryItems = queryItems
		guard let url = urlComponents.url else { return nil }
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.allHTTPHeaderFields = headers
		request.httpBody = body
		return interceptor?.adapt(request: request) ?? request
	}
	
	/// Builds the task to execute requests
	///
	/// - Parameters:
	///   - request: Request to be executed
	///   - callback: Closure to be executed with the results of the request
	func buildTask(request: URLRequest?, callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		guard let request = request else { return nil }
		let task = session.dataTask(with: request) { [weak self, request] data, response, error in
			if self != nil {
				callback(RestResponse(data: data, request: request, response: response, error: error))
			}
		}
		if resumeTasksAutomatically {
			task.resume()
		}
		return task
	}
	
	/// Builds the path from a list of RestPath
	///
	/// - Parameters:
	///   - path: List of RestPath
	func buildPath(_ path: [RestPath]) -> String {
		let stringPaths = path.map { $0.rawValue }
		let fullPath = "/" + stringPaths.joined(separator: "/")
		return fullPath
	}
}

// MARK: - RequestExecutable
extension RestService: RequestExecutable {
	
	@discardableResult
	public func json(method: HTTPMethod,
					 path: String,
					 interceptor: RestRequestInterceptor?,
					 callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		let request = buildRequest(method: method,
								   path: path,
								   queryItems: nil,
								   headers: jsonHeaders(),
								   body: nil,
								   interceptor: interceptor)
		return buildTask(request: request, callback: callback)
	}
	
	@discardableResult
	public func json(method: HTTPMethod,
					 path: [RestPath],
					 interceptor: RestRequestInterceptor?,
					 callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		return json(method: method,
					path: buildPath(path),
					interceptor: interceptor,
					callback: callback)
	}
	
	@discardableResult
	public func json<T: Codable>(method: HTTPMethod,
								 path: String,
								 parameters: T,
								 interceptor: RestRequestInterceptor?,
								 callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		var queryItems: [URLQueryItem]? = nil
		var body: Data? = nil
		if method == .get || method == .head || method == .delete {
			queryItems = buildQueryItems(parameters: parameters)
		} else {
			body = buildJsonBody(parameters: parameters)
		}
		let request = buildRequest(method: method,
								   path: path,
								   queryItems: queryItems,
								   headers: jsonHeaders(),
								   body: body,
								   interceptor: interceptor)
		return buildTask(request: request, callback: callback)
	}
	
	@discardableResult
	public func json<T: Codable>(method: HTTPMethod,
								 path: [RestPath],
								 parameters: T,
								 interceptor: RestRequestInterceptor?,
								 callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		return json(method: method,
					path: buildPath(path),
					parameters: parameters,
					interceptor: interceptor,
					callback: callback)
	}
	
	@discardableResult
	public func json(method: HTTPMethod,
					 path: String,
					 parameters: [String: Any],
					 interceptor: RestRequestInterceptor?,
					 callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		var queryItems: [URLQueryItem]? = nil
		var body: Data? = nil
		if method == .get || method == .head || method == .delete {
			queryItems = buildQueryItems(parameters: parameters)
		} else {
			body = buildJsonBody(parameters: parameters)
		}
		let request = buildRequest(method: method,
								   path: path,
								   queryItems: queryItems,
								   headers: jsonHeaders(),
								   body: body,
								   interceptor: interceptor)
		return buildTask(request: request, callback: callback)
	}
	
	@discardableResult
	public func json(method: HTTPMethod,
					 path: [RestPath],
					 parameters: [String: Any],
					 interceptor: RestRequestInterceptor?,
					 callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		return json(method: method,
					path: buildPath(path),
					parameters: parameters,
					interceptor: interceptor,
					callback: callback)
	}
	
	@discardableResult
	public func formData(method: HTTPMethod,
						 path: String,
						 parameters: [FormDataParameter],
						 interceptor: RestRequestInterceptor?,
						 callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		let boundary = UUID().uuidString
		let body = buildFormDataBody(boundary: boundary, parameters: parameters)
		let request = buildRequest(method: method,
								   path: path,
								   queryItems: nil,
								   headers: formDataHeaders(boundary: boundary),
								   body: body,
								   interceptor: interceptor)
		return buildTask(request: request, callback: callback)
	}
	
	@discardableResult
	public func formData(method: HTTPMethod,
						 path: [RestPath],
						 parameters: [FormDataParameter],
						 interceptor: RestRequestInterceptor?,
						 callback: @escaping (RestResponse) -> Void) -> RestDataTask? {
		
		return formData(method: method,
						path: buildPath(path),
						parameters: parameters,
						interceptor: interceptor,
						callback: callback)
	}
}
