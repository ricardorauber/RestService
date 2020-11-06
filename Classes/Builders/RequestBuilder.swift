import Foundation

struct RequestBuilder {
    
    func build(scheme: HTTPScheme,
               method: HTTPMethod,
               host: String,
               path: String,
               port: Int? = nil,
               queryItems: [URLQueryItem]? = nil,
               body: Data? = nil,
               interceptor: RequestInterceptor? = nil) -> URLRequest? {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host
        urlComponents.port = port
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        return interceptor?.adapt(request: request) ?? request
    }
}
