public class RestService {
	
	let session: URLSession
	let scheme: HTTPScheme
	let host: String
	let port: Int?
	var resumeTasksAutomatically = true
	
	// MARK: - Initialization
	
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
	
	func buildQueryItems<T: Codable>(parameters: T) -> [URLQueryItem] {
		var queryItems: [URLQueryItem] = []
		guard let encoded = try? JSONEncoder().encode(parameters),
			let decoded = try? JSONSerialization.jsonObject(with: encoded, options: .mutableContainers) as? [String: Any]
			else {
				return queryItems
		}
		for (key, value) in decoded {
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
	
	func jsonHeaders() -> [String: String] {
		return [
			"Content-Type": "application/json"
		]
	}
	
	func formDataHeaders(boundary: String) -> [String: String] {
		return [
			"Content-Type": "multipart/form-data; boundary=" + boundary
		]
	}
	
	func buildJsonBody<T: Codable>(parameters: T) -> Data? {
		return try? JSONEncoder().encode(parameters)
	}
	
	func buildFormDataBody(boundary: String, parameters: [FormDataParameter]) -> Data? {
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
		return interceptor?.adapt(url: request) ?? request
	}
}

// MARK: - HTTPService
extension RestService: HTTPService {
	
	@discardableResult
	func json(method: HTTPMethod,
			  path: String,
			  interceptor: RestRequestInterceptor?,
			  callback: @escaping () -> Void) -> RestDataTask? {
		
		if let request = buildRequest(method: method,
									  path: path,
									  queryItems: nil,
									  headers: jsonHeaders(),
									  body: nil,
									  interceptor: interceptor) {
			
			let task = session.dataTask(with: request) { [weak self] data, response, error in
				if self != nil {
					callback()
				}
			}
			if resumeTasksAutomatically {
				task.resume()
			}
			return task
		}
		return nil
	}
	
	@discardableResult
	func json<T: Codable>(method: HTTPMethod,
						  path: String,
						  parameters: T,
						  interceptor: RestRequestInterceptor?,
						  callback: @escaping () -> Void) -> RestDataTask? {
		
		var queryItems: [URLQueryItem]? = nil
		var body: Data? = nil
		if method == .get || method == .head {
			queryItems = buildQueryItems(parameters: parameters)
		} else {
			body = buildJsonBody(parameters: parameters)
		}
		if let request = buildRequest(method: method,
									  path: path,
									  queryItems: queryItems,
									  headers: jsonHeaders(),
									  body: body,
									  interceptor: interceptor) {
			let task = session.dataTask(with: request) { [weak self] data, response, error in
				if self != nil {
					callback()
				}
			}
			if resumeTasksAutomatically {
				task.resume()
			}
			return task
		}
		return nil
	}
	
	@discardableResult
	func formData(method: HTTPMethod,
				  path: String,
				  parameters: [FormDataParameter],
				  interceptor: RestRequestInterceptor?,
				  callback: @escaping () -> Void) -> RestDataTask? {
		
		let boundary = UUID().uuidString
		let body = buildFormDataBody(boundary: boundary, parameters: parameters)
		if let request = buildRequest(method: method,
									  path: path,
									  queryItems: nil,
									  headers: formDataHeaders(boundary: boundary),
									  body: body,
									  interceptor: interceptor) {
			let task = session.dataTask(with: request) { [weak self] data, response, error in
				if self != nil {
					callback()
				}
			}
			if resumeTasksAutomatically {
				task.resume()
			}
			return task
		}
		return nil
	}
}
