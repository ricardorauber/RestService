/// Protocol to make requests
public protocol RequestExecutable {
	
	/// Creates a task to run a JSON request without parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - interceptor: Adapts the request after creation
	///   - callback: Closure to be executed with the results of the request
	@discardableResult
	func json(method: HTTPMethod,
			  path: String,
			  interceptor: RestRequestInterceptor?,
			  callback: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a JSON request without parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - interceptor: Adapts the request after creation
	///   - callback: Closure to be executed with the results of the request
	@discardableResult
	func json(method: HTTPMethod,
			  path: [RestPath],
			  interceptor: RestRequestInterceptor?,
			  callback: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a JSON request with parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: Codable object with the parameters
	///   - interceptor: Adapts the request after creation
	///   - callback: Closure to be executed with the results of the request
	@discardableResult
	func json<T: Codable>(method: HTTPMethod,
						  path: String,
						  parameters: T,
						  interceptor: RestRequestInterceptor?,
						  callback: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a JSON request with parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: Codable object with the parameters
	///   - interceptor: Adapts the request after creation
	///   - callback: Closure to be executed with the results of the request
	@discardableResult
	func json<T: Codable>(method: HTTPMethod,
						  path: [RestPath],
						  parameters: T,
						  interceptor: RestRequestInterceptor?,
						  callback: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a JSON request with parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: Dictionary with the parameters
	///   - interceptor: Adapts the request after creation
	///   - callback: Closure to be executed with the results of the request
	@discardableResult
	func json(method: HTTPMethod,
			  path: String,
			  parameters: [String: Any],
			  interceptor: RestRequestInterceptor?,
			  callback: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a JSON request with parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: Dictionary with the parameters
	///   - interceptor: Adapts the request after creation
	///   - callback: Closure to be executed with the results of the request
	@discardableResult
	func json(method: HTTPMethod,
			  path: [RestPath],
			  parameters: [String: Any],
			  interceptor: RestRequestInterceptor?,
			  callback: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a Form Data request with parameters
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: List of parameters
	///   - interceptor: Adapts the request after creation
	///   - callback: Closure to be executed with the results of the request
	@discardableResult
	func formData(method: HTTPMethod,
				  path: String,
				  parameters: [FormDataParameter],
				  interceptor: RestRequestInterceptor?,
				  callback: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a Form Data request with parameters
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: List of parameters
	///   - interceptor: Adapts the request after creation
	///   - callback: Closure to be executed with the results of the request
	@discardableResult
	func formData(method: HTTPMethod,
				  path: [RestPath],
				  parameters: [FormDataParameter],
				  interceptor: RestRequestInterceptor?,
				  callback: @escaping (RestResponse) -> Void) -> RestDataTask?
}
