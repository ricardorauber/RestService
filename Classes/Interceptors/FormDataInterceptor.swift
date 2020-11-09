import Foundation

public struct FormDataInterceptor {
    
    // MARK: - Properties
    
    public let boundary: String
    
    // MARK: - Initialization
    
    public init(boundary: String) {
        self.boundary = boundary
    }
}

// MARK: - RequestInterceptor
extension FormDataInterceptor: RequestInterceptor {
    
    public func adapt(request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("multipart/form-data; boundary=" + boundary, forHTTPHeaderField: "Content-Type")
        return request
    }
}
