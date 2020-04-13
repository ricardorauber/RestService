protocol HTTPService {
	
	@discardableResult
	func json(method: HTTPMethod,
			  path: String,
			  interceptor: RestRequestInterceptor?,
			  callback: @escaping () -> Void) -> RestDataTask?
	
	@discardableResult
	func json<T: Codable>(method: HTTPMethod,
						  path: String,
						  parameters: T,
						  interceptor: RestRequestInterceptor?,
						  callback: @escaping () -> Void) -> RestDataTask?
	
	@discardableResult
	func formData(method: HTTPMethod,
				  path: String,
				  parameters: [FormDataParameter],
				  interceptor: RestRequestInterceptor?,
				  callback: @escaping () -> Void) -> RestDataTask?
}
