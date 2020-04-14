protocol RestRequestInterceptor {

	func adapt(request: URLRequest) -> URLRequest
}
