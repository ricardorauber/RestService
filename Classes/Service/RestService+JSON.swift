import Foundation

extension RestService {
    
    // MARK: - No Parameters
    
    func prepareJson(method: HTTPMethod,
                     path: String,
                     interceptor: RequestInterceptor?,
                     progress: ((Double) -> Void)?,
                     completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: path,
                queryItems: nil,
                body: nil,
                interceptor: interceptorBuilder.buildJson(interceptor: interceptor))
        else {
            return nil
        }
        return taskBuilder.build(session: session,
                                 request: request,
                                 autoResume: startTasksAutomatically,
                                 progress: progress,
                                 completion: completion)
    }
    
    @discardableResult
    public func json(method: HTTPMethod,
                     path: String,
                     interceptor: RequestInterceptor?,
                     progress: ((Double) -> Void)?,
                     completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    @discardableResult
    public func json<D: Decodable>(method: HTTPMethod,
                                   path: String,
                                   interceptor: RequestInterceptor?,
                                   responseType: D.Type,
                                   progress: ((Double) -> Void)?,
                                   completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response, responseType: responseType))
        }
    }
    
    @discardableResult
    public func json<E: Decodable>(method: HTTPMethod,
                                   path: String,
                                   interceptor: RequestInterceptor?,
                                   customError: E.Type,
                                   progress: ((Double) -> Void)?,
                                   completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response, customError: customError))
        }
    }
    
    @discardableResult
    public func json<D: Decodable,
                     E: Decodable>(method: HTTPMethod,
                                   path: String,
                                   interceptor: RequestInterceptor?,
                                   responseType: D.Type,
                                   customError: E.Type,
                                   progress: ((Double) -> Void)?,
                                   completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response, responseType: responseType, customError: customError))
        }
    }
    
    // MARK: - Codable Parameters
    
    func prepareJson<P: Codable>(method: HTTPMethod,
                                 path: String,
                                 parameters: P,
                                 interceptor: RequestInterceptor?,
                                 progress: ((Double) -> Void)?,
                                 completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: path,
                queryItems: queryBuilder.build(method: method, parameters: parameters),
                body: bodyBuilder.buildJson(method: method, parameters: parameters),
                interceptor: interceptorBuilder.buildJson(interceptor: interceptor))
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
    public func json<P: Codable>(method: HTTPMethod,
                                 path: String,
                                 parameters: P,
                                 interceptor: RequestInterceptor?,
                                 progress: ((Double) -> Void)?,
                                 completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           parameters: parameters,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    @discardableResult
    public func json<P: Codable,
                     D: Decodable>(method: HTTPMethod,
                                   path: String,
                                   parameters: P,
                                   interceptor: RequestInterceptor?,
                                   responseType: D.Type,
                                   progress: ((Double) -> Void)?,
                                   completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           parameters: parameters,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response, responseType: responseType))
        }
    }
    
    @discardableResult
    public func json<P: Codable,
                     E: Decodable>(method: HTTPMethod,
                                   path: String,
                                   parameters: P,
                                   interceptor: RequestInterceptor?,
                                   customError: E.Type,
                                   progress: ((Double) -> Void)?,
                                   completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           parameters: parameters,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response, customError: customError))
        }
    }
    
    @discardableResult
    public func json<P: Codable,
                     D: Decodable,
                     E: Decodable>(method: HTTPMethod,
                                   path: String,
                                   parameters: P,
                                   interceptor: RequestInterceptor?,
                                   responseType: D.Type,
                                   customError: E.Type,
                                   progress: ((Double) -> Void)?,
                                   completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           parameters: parameters,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response, responseType: responseType, customError: customError))
        }
    }
    
    // MARK: - Dictionary Parameters
    
    func prepareJson(method: HTTPMethod,
                     path: String,
                     parameters: [String: Any],
                     interceptor: RequestInterceptor?,
                     progress: ((Double) -> Void)?,
                     completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: path,
                queryItems: queryBuilder.build(method: method, parameters: parameters),
                body: bodyBuilder.buildJson(method: method, parameters: parameters),
                interceptor: interceptorBuilder.buildJson(interceptor: interceptor))
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
    public func json(method: HTTPMethod,
                     path: String,
                     parameters: [String: Any],
                     interceptor: RequestInterceptor?,
                     progress: ((Double) -> Void)?,
                     completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           parameters: parameters,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    @discardableResult
    public func json<D: Decodable>(method: HTTPMethod,
                                   path: String,
                                   parameters: [String: Any],
                                   interceptor: RequestInterceptor?,
                                   responseType: D.Type,
                                   progress: ((Double) -> Void)?,
                                   completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           parameters: parameters,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response, responseType: responseType))
        }
    }
    
    @discardableResult
    public func json<E: Decodable>(method: HTTPMethod,
                                   path: String,
                                   parameters: [String: Any],
                                   interceptor: RequestInterceptor?,
                                   customError: E.Type,
                                   progress: ((Double) -> Void)?,
                                   completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           parameters: parameters,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response, customError: customError))
        }
    }
    
    @discardableResult
    public func json<D: Decodable,
                     E: Decodable>(method: HTTPMethod,
                                   path: String,
                                   parameters: [String: Any],
                                   interceptor: RequestInterceptor?,
                                   responseType: D.Type,
                                   customError: E.Type,
                                   progress: ((Double) -> Void)?,
                                   completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareJson(method: method,
                           path: path,
                           parameters: parameters,
                           interceptor: interceptor,
                           progress: progress) { response in
            completion(self.prepare(response: response, responseType: responseType, customError: customError))
        }
    }
}
