import Foundation

extension RestService {
    
    // MARK: Prepare
    
    func prepareFormData(debug: Bool? = nil,
                         boundary: String = UUID().uuidString,
                         method: HTTPMethod,
                         path: String,
                         parameters: [FormDataParameter],
                         interceptor: RequestInterceptor? = nil,
                         progress: ((Double) -> Void)? = nil,
                         completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: fullPath(with: path),
                port: port,
                body: bodyBuilder.buildFormData(method: method, boundary: boundary, parameters: parameters),
                interceptor: interceptorBuilder.buildFormData(boundary: boundary, interceptor: interceptor))
        else {
            return nil
        }
        return taskBuilder.build(
            session: session,
            decoder: decoder,
            debug: debug ?? self.debug,
            request: request,
            autoResume: startTasksAutomatically,
            progress: progress,
            completion: completion
        )
    }
    
    // MARK: Simple
    
    @discardableResult
    open func formData(debug: Bool? = nil,
                       method: HTTPMethod,
                       path: String,
                       parameters: [FormDataParameter],
                       interceptor: RequestInterceptor? = nil,
                       progress: ((Double) -> Void)? = nil,
                       completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareFormData(debug: debug,
                               method: method,
                               path: path,
                               parameters: parameters,
                               interceptor: interceptor,
                               progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    // MARK: With Response Type
    
    @discardableResult
    open func formData<D: Decodable>(debug: Bool? = nil,
                                     method: HTTPMethod,
                                     path: String,
                                     parameters: [FormDataParameter],
                                     interceptor: RequestInterceptor? = nil,
                                     responseType: D.Type,
                                     progress: ((Double) -> Void)? = nil,
                                     completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareFormData(debug: debug,
                               method: method,
                               path: path,
                               parameters: parameters,
                               interceptor: interceptor,
                               progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType))
        }
    }
    
    // MARK: With Custom Error
    
    @discardableResult
    open func formData<E: Decodable & Error>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: [FormDataParameter],
                                             interceptor: RequestInterceptor? = nil,
                                             customError: E.Type,
                                             progress: ((Double) -> Void)? = nil,
                                             completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareFormData(debug: debug,
                               method: method,
                               path: path,
                               parameters: parameters,
                               interceptor: interceptor,
                               progress: progress) { response in
            completion(self.prepare(response: response,
                                    customError: customError))
        }
    }
    
    // MARK: With Response Type and Custom Error
    
    @discardableResult
    open func formData<D: Decodable,
                       E: Decodable>(debug: Bool? = nil,
                                     method: HTTPMethod,
                                     path: String,
                                     parameters: [FormDataParameter],
                                     interceptor: RequestInterceptor? = nil,
                                     responseType: D.Type,
                                     customError: E.Type,
                                     progress: ((Double) -> Void)? = nil,
                                     completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareFormData(debug: debug,
                               method: method,
                               path: path,
                               parameters: parameters,
                               interceptor: interceptor,
                               progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType,
                                    customError: customError))
        }
    }
}
