protocol RestRequestInterceptor {

	func adapt(url: URLRequest) -> URLRequest
}
