import Foundation

public struct FormUrlEncodedInterceptor: RequestInterceptor {
    
    public func adapt(request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }
}
