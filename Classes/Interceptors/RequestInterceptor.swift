/// Protocol to adapt requests
public protocol RequestInterceptor {
	
	/// Adapts a given request
	///
	/// - Parameter request: Request to be adapted
	func adapt(request: URLRequest) -> URLRequest
}
