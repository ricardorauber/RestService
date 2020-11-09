import Foundation

public struct GroupInterceptor {
    
    // MARK: - Properties
    
    public let interceptors: [RequestInterceptor]
    
    // MARK: - Initialization
    
    public init(interceptors: [RequestInterceptor]) {
        self.interceptors = interceptors
    }
}

// MARK: - RequestInterceptor
extension GroupInterceptor: RequestInterceptor {
    
    public func adapt(request: URLRequest) -> URLRequest {
        var request = request
        for interceptor in interceptors {
            request = interceptor.adapt(request: request)
        }
        return request
    }
}
