import Foundation

/// An implementation of the RestRequestInterceptor that uses multiple interceptors for the same request
public struct RestInterceptorGroup {
    
    /// List of interceptors
    public let interceptors: [RestRequestInterceptor]
    
    // MARK: - Initialization
    
    /// Creates a new instance of the RestInterceptorGroup
    /// - Parameter interceptors: List of interceptors
    public init(interceptors: [RestRequestInterceptor]) {
        self.interceptors = interceptors
    }
}

// MARK: - RestRequestInterceptor
extension RestInterceptorGroup: RestRequestInterceptor {
    
    public func adapt(request: URLRequest) -> URLRequest {
        var request = request
        for interceptor in interceptors {
            request = interceptor.adapt(request: request)
        }
        return request
    }
}
