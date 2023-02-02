import Foundation

public struct JSONInterceptor: RequestInterceptor {
    
    public func adapt(request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}
