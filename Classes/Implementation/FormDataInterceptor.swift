import Foundation

/// An implementation of the RestRequestInterceptor that set the Content-Type to multipart/form-data
public struct FormDataInterceptor {
    
    /// Boundary used in the request
    let boundary: String
    
    /// creates a new instance og the FormDataInterceptor
    /// - Parameter boundary: Boundary used in the request
    public init(boundary: String) {
        self.boundary = boundary
    }
}

// MARK: - RestRequestInterceptor
extension FormDataInterceptor: RestRequestInterceptor {
    
    public func adapt(request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        return request
    }
}
