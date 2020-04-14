/// Protocol to adapt requests
public protocol RestRequestInterceptor {
	
	/// Adapts a given request
	///
	/// - Parameter request: Request to be adapted
	func adapt(request: URLRequest) -> URLRequest
}
