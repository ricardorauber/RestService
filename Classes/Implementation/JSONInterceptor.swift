import Foundation

/// An implementation of the RestRequestInterceptor that set the Content-Type to JSON
public struct JSONInterceptor: RestRequestInterceptor {
    
    public func adapt(request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}
