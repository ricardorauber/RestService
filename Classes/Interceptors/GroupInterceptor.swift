import Foundation

/// An implementation of the GroupInterceptor that uses multiple interceptors for the same request
public struct GroupInterceptor {
    
    /// List of interceptors
    public let interceptors: [RequestInterceptor]
    
    // MARK: - Initialization
    
    /// Creates a new instance of the GroupInterceptor
    /// - Parameter interceptors: List of interceptors
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
