import Foundation

struct InterceptorBuilder {
    
    func buildJson(interceptor: RequestInterceptor? = nil) -> RequestInterceptor {
        var interceptors: [RequestInterceptor] = [JSONInterceptor()]
        if let interceptor = interceptor {
            interceptors.append(interceptor)
        }
        return GroupInterceptor(interceptors: interceptors)
    }
    
    func buildFormData(boundary: String, interceptor: RequestInterceptor? = nil) -> RequestInterceptor {
        var interceptors: [RequestInterceptor] = [FormDataInterceptor(boundary: boundary)]
        if let interceptor = interceptor {
            interceptors.append(interceptor)
        }
        return GroupInterceptor(interceptors: interceptors)
    }
    
    func buildFormUrlEncoded(interceptor: RequestInterceptor? = nil) -> RequestInterceptor {
        var interceptors: [RequestInterceptor] = [FormUrlEncodedInterceptor()]
        if let interceptor = interceptor {
            interceptors.append(interceptor)
        }
        return GroupInterceptor(interceptors: interceptors)
    }
}
