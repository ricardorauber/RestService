import Foundation

extension RestService {
    
    func prepareFormData(method: HTTPMethod,
                         path: String,
                         parameters: [FormDataParameter],
                         interceptor: RequestInterceptor?,
                         progress: ((Double) -> Void)?,
                         completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        let boundary = UUID().uuidString
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: path,
                queryItems: nil,
                body: bodyBuilder.buildFormData(method: method, boundary: boundary, parameters: parameters),
                interceptor: interceptorBuilder.buildFormData(boundary: boundary, interceptor: interceptor))
        else {
            return nil
        }
        return taskBuilder.build(
            session: session,
            request: request,
            autoResume: startTasksAutomatically,
            progress: progress,
            completion: completion
        )
    }
    
    @discardableResult
    public func formData(method: HTTPMethod,
                         path: String,
                         parameters: [FormDataParameter],
                         interceptor: RequestInterceptor?,
                         progress: ((Double) -> Void)?,
                         completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareFormData(method: method,
                               path: path,
                               parameters: parameters,
                               interceptor: interceptor,
                               progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    @discardableResult
    public func formData<D: Decodable>(method: HTTPMethod,
                                       path: String,
                                       parameters: [FormDataParameter],
                                       interceptor: RequestInterceptor?,
                                       responseType: D.Type,
                                       progress: ((Double) -> Void)?,
                                       completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareFormData(method: method,
                               path: path,
                               parameters: parameters,
                               interceptor: interceptor,
                               progress: progress) { response in
            completion(self.prepare(response: response, responseType: responseType))
        }
    }
    
    @discardableResult
    public func formData<E: Decodable>(method: HTTPMethod,
                                       path: String,
                                       parameters: [FormDataParameter],
                                       interceptor: RequestInterceptor?,
                                       customError: E.Type,
                                       progress: ((Double) -> Void)?,
                                       completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareFormData(method: method,
                               path: path,
                               parameters: parameters,
                               interceptor: interceptor,
                               progress: progress) { response in
            completion(self.prepare(response: response, customError: customError))
        }
    }
    
    @discardableResult
    public func formData<D: Decodable,
                         E: Decodable>(method: HTTPMethod,
                                       path: String,
                                       parameters: [FormDataParameter],
                                       interceptor: RequestInterceptor?,
                                       responseType: D.Type,
                                       customError: E.Type,
                                       progress: ((Double) -> Void)?,
                                       completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareFormData(method: method,
                               path: path,
                               parameters: parameters,
                               interceptor: interceptor,
                               progress: progress) { response in
            completion(self.prepare(response: response, responseType: responseType, customError: customError))
        }
    }
}
