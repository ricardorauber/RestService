/// Protocol to make requests
public protocol RestServiceProtocol {
	
	/// Creates a task to run a JSON request without parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - interceptor: Adapts the request after creation
    ///   - progress: Closure to be executed while the execution is in progress
	///   - completion: Closure to be executed with the results of the request
	@discardableResult
	func json(method: HTTPMethod,
			  path: String,
			  interceptor: RequestInterceptor?,
              progress: ((Double) -> Void)?,
			  completion: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a JSON request without parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - interceptor: Adapts the request after creation
    ///   - progress: Closure to be executed while the execution is in progress
	///   - completion: Closure to be executed with the results of the request
	@discardableResult
	func json(method: HTTPMethod,
			  path: [RestPath],
			  interceptor: RequestInterceptor?,
              progress: ((Double) -> Void)?,
			  completion: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a JSON request with parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: Codable object with the parameters
	///   - interceptor: Adapts the request after creation
    ///   - progress: Closure to be executed while the execution is in progress
	///   - completion: Closure to be executed with the results of the request
	@discardableResult
	func json<T: Codable>(method: HTTPMethod,
						  path: String,
						  parameters: T,
						  interceptor: RequestInterceptor?,
                          progress: ((Double) -> Void)?,
						  completion: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a JSON request with parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: Codable object with the parameters
	///   - interceptor: Adapts the request after creation
    ///   - progress: Closure to be executed while the execution is in progress
	///   - completion: Closure to be executed with the results of the request
	@discardableResult
	func json<T: Codable>(method: HTTPMethod,
						  path: [RestPath],
						  parameters: T,
						  interceptor: RequestInterceptor?,
                          progress: ((Double) -> Void)?,
						  completion: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a JSON request with parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: Dictionary with the parameters
	///   - interceptor: Adapts the request after creation
    ///   - progress: Closure to be executed while the execution is in progress
	///   - completion: Closure to be executed with the results of the request
	@discardableResult
	func json(method: HTTPMethod,
			  path: String,
			  parameters: [String: Any],
			  interceptor: RequestInterceptor?,
              progress: ((Double) -> Void)?,
			  completion: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a JSON request with parameters
	///
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: Dictionary with the parameters
	///   - interceptor: Adapts the request after creation
    ///   - progress: Closure to be executed while the execution is in progress
	///   - completion: Closure to be executed with the results of the request
	@discardableResult
	func json(method: HTTPMethod,
			  path: [RestPath],
			  parameters: [String: Any],
			  interceptor: RequestInterceptor?,
              progress: ((Double) -> Void)?,
			  completion: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a Form Data request with parameters
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: List of parameters
	///   - interceptor: Adapts the request after creation
    ///   - progress: Closure to be executed while the execution is in progress
	///   - completion: Closure to be executed with the results of the request
	@discardableResult
	func formData(method: HTTPMethod,
				  path: String,
				  parameters: [FormDataParameter],
				  interceptor: RequestInterceptor?,
                  progress: ((Double) -> Void)?,
				  completion: @escaping (RestResponse) -> Void) -> RestDataTask?
	
	/// Creates a task to run a Form Data request with parameters
	/// - Parameters:
	///   - method: HTTP method
	///   - path: Path of the server URI
	///   - parameters: List of parameters
	///   - interceptor: Adapts the request after creation
    ///   - progress: Closure to be executed while the execution is in progress
	///   - completion: Closure to be executed with the results of the request
	@discardableResult
	func formData(method: HTTPMethod,
				  path: [RestPath],
				  parameters: [FormDataParameter],
				  interceptor: RequestInterceptor?,
                  progress: ((Double) -> Void)?,
				  completion: @escaping (RestResponse) -> Void) -> RestDataTask?
}
