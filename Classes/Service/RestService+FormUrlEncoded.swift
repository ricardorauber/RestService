import Foundation

// MARK: - Form Url Encoded Without Parameters
extension RestService {
    
    // MARK: Prepare
    
    func prepareFormUrlEncoded(debug: Bool? = nil,
                               method: HTTPMethod,
                               path: String,
                               interceptor: RequestInterceptor? = nil,
                               retryAttempts: Int? = nil,
                               retryDelay: UInt32? = nil,
                               retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                               progress: ((Double) -> Void)? = nil,
                               completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: fullPath(with: path),
                port: port,
                interceptor: interceptorBuilder.buildFormUrlEncoded(interceptor: interceptor))
        else {
            return nil
        }
        return taskBuilder.build(
            session: session,
            decoder: decoder,
            debug: debug ?? self.debug,
            request: request,
            autoResume: startTasksAutomatically,
            retryAttempts: retryAttempts ?? self.retryAttempts,
            retryDelay: retryDelay ?? self.retryDelay,
            retryAdapter: retryAdapter,
            progress: progress,
            completion: completion
        )
    }
    
    // MARK: Simple
    
    @discardableResult
    open func formUrlEncoded(debug: Bool? = nil,
                             method: HTTPMethod,
                             path: String,
                             interceptor: RequestInterceptor? = nil,
                             retryAttempts: Int? = nil,
                             retryDelay: UInt32? = nil,
                             retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                             progress: ((Double) -> Void)? = nil,
                             completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    // MARK: With Response Type
    
    @discardableResult
    open func formUrlEncoded<D: Decodable>(debug: Bool? = nil,
                                           method: HTTPMethod,
                                           path: String,
                                           interceptor: RequestInterceptor? = nil,
                                           responseType: D.Type,
                                           retryAttempts: Int? = nil,
                                           retryDelay: UInt32? = nil,
                                           retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                                           progress: ((Double) -> Void)? = nil,
                                           completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType))
        }
    }
    
    // MARK: With Custom Error
    
    @discardableResult
    open func formUrlEncoded<E: Decodable & Error>(debug: Bool? = nil,
                                                   method: HTTPMethod,
                                                   path: String,
                                                   interceptor: RequestInterceptor? = nil,
                                                   customError: E.Type,
                                                   retryAttempts: Int? = nil,
                                                   retryDelay: UInt32? = nil,
                                                   retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                                                   progress: ((Double) -> Void)? = nil,
                                                   completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    customError: customError))
        }
    }
    
    // MARK: With Response Type and Custom Error
    
    @discardableResult
    open func formUrlEncoded<D: Decodable,
                             E: Decodable>(debug: Bool? = nil,
                                           method: HTTPMethod,
                                           path: String,
                                           interceptor: RequestInterceptor? = nil,
                                           responseType: D.Type,
                                           customError: E.Type,
                                           retryAttempts: Int? = nil,
                                           retryDelay: UInt32? = nil,
                                           retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                                           progress: ((Double) -> Void)? = nil,
                                           completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType,
                                    customError: customError))
        }
    }
}

// MARK: - Form Url Encoded With Codable Parameters
extension RestService {
    
    // MARK: Prepare
    
    func prepareFormUrlEncoded<P: Codable>(debug: Bool? = nil,
                                           method: HTTPMethod,
                                           path: String,
                                           parameters: P,
                                           interceptor: RequestInterceptor? = nil,
                                           retryAttempts: Int? = nil,
                                           retryDelay: UInt32? = nil,
                                           retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                                           progress: ((Double) -> Void)? = nil,
                                           completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: fullPath(with: path),
                port: port,
                queryItems: queryBuilder.build(method: method, parameters: parameters),
                body: bodyBuilder.buildFormUrlEncoded(method: method, parameters: parameters),
                interceptor: interceptorBuilder.buildFormUrlEncoded(interceptor: interceptor))
        else {
            return nil
        }
        return taskBuilder.build(
            session: session,
            decoder: decoder,
            debug: debug ?? self.debug,
            request: request,
            autoResume: startTasksAutomatically,
            retryAttempts: retryAttempts ?? self.retryAttempts,
            retryDelay: retryDelay ?? self.retryDelay,
            retryAdapter: retryAdapter,
            progress: progress,
            completion: completion
        )
    }
    
    // MARK: Simple
    
    @discardableResult
    open func formUrlEncoded<P: Codable>(debug: Bool? = nil,
                                         method: HTTPMethod,
                                         path: String,
                                         parameters: P,
                                         interceptor: RequestInterceptor? = nil,
                                         retryAttempts: Int? = nil,
                                         retryDelay: UInt32? = nil,
                                         retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                                         progress: ((Double) -> Void)? = nil,
                                         completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    // MARK: With Response Type
    
    @discardableResult
    open func formUrlEncoded<P: Codable,
                             D: Decodable>(debug: Bool? = nil,
                                           method: HTTPMethod,
                                           path: String,
                                           parameters: P,
                                           interceptor: RequestInterceptor? = nil,
                                           responseType: D.Type,
                                           retryAttempts: Int? = nil,
                                           retryDelay: UInt32? = nil,
                                           retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                                           progress: ((Double) -> Void)? = nil,
                                           completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType))
        }
    }
    
    // MARK: With Custom Error
    
    @discardableResult
    open func formUrlEncoded<P: Codable,
                             E: Decodable>(debug: Bool? = nil,
                                           method: HTTPMethod,
                                           path: String,
                                           parameters: P,
                                           interceptor: RequestInterceptor? = nil,
                                           customError: E.Type,
                                           retryAttempts: Int? = nil,
                                           retryDelay: UInt32? = nil,
                                           retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                                           progress: ((Double) -> Void)? = nil,
                                           completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    customError: customError))
        }
    }
    
    // MARK: With Response Type and Custom Error
    
    @discardableResult
    open func formUrlEncoded<P: Codable,
                             D: Decodable,
                             E: Decodable>(debug: Bool? = nil,
                                           method: HTTPMethod,
                                           path: String,
                                           parameters: P,
                                           interceptor: RequestInterceptor? = nil,
                                           responseType: D.Type,
                                           customError: E.Type,
                                           retryAttempts: Int? = nil,
                                           retryDelay: UInt32? = nil,
                                           retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                                           progress: ((Double) -> Void)? = nil,
                                           completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType,
                                    customError: customError))
        }
    }
}

// MARK: - Form Url Encoded With Dictionary Parameters
extension RestService {
    
    // MARK: Prepare
    
    func prepareFormUrlEncoded(debug: Bool? = nil,
                               method: HTTPMethod,
                               path: String,
                               parameters: [String: Any],
                               interceptor: RequestInterceptor? = nil,
                               retryAttempts: Int? = nil,
                               retryDelay: UInt32? = nil,
                               retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                               progress: ((Double) -> Void)? = nil,
                               completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: fullPath(with: path),
                port: port,
                queryItems: queryBuilder.build(method: method, parameters: parameters),
                body: bodyBuilder.buildFormUrlEncoded(method: method, parameters: parameters),
                interceptor: interceptorBuilder.buildFormUrlEncoded(interceptor: interceptor))
        else {
            return nil
        }
        return taskBuilder.build(
            session: session,
            decoder: decoder,
            debug: debug ?? self.debug,
            request: request,
            autoResume: startTasksAutomatically,
            retryAttempts: retryAttempts ?? self.retryAttempts,
            retryDelay: retryDelay ?? self.retryDelay,
            retryAdapter: retryAdapter,
            progress: progress,
            completion: completion
        )
    }
    
    // MARK: Simple
    
    @discardableResult
    open func formUrlEncoded(debug: Bool? = nil,
                             method: HTTPMethod,
                             path: String,
                             parameters: [String: Any],
                             interceptor: RequestInterceptor? = nil,
                             retryAttempts: Int? = nil,
                             retryDelay: UInt32? = nil,
                             retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                             progress: ((Double) -> Void)? = nil,
                             completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    // MARK: With Response Type
    
    @discardableResult
    open func formUrlEncoded<D: Decodable>(debug: Bool? = nil,
                                           method: HTTPMethod,
                                           path: String,
                                           parameters: [String: Any],
                                           interceptor: RequestInterceptor? = nil,
                                           responseType: D.Type,
                                           retryAttempts: Int? = nil,
                                           retryDelay: UInt32? = nil,
                                           retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                                           progress: ((Double) -> Void)? = nil,
                                           completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType))
        }
    }
    
    // MARK: With Custom Error
    
    @discardableResult
    open func formUrlEncoded<E: Decodable & Error>(debug: Bool? = nil,
                                                   method: HTTPMethod,
                                                   path: String,
                                                   parameters: [String: Any],
                                                   interceptor: RequestInterceptor? = nil,
                                                   customError: E.Type,
                                                   retryAttempts: Int? = nil,
                                                   retryDelay: UInt32? = nil,
                                                   retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                                                   progress: ((Double) -> Void)? = nil,
                                                   completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    customError: customError))
        }
    }
    
    // MARK: With Response Type and Custom Error
    
    @discardableResult
    open func formUrlEncoded<D: Decodable,
                             E: Decodable>(debug: Bool? = nil,
                                           method: HTTPMethod,
                                           path: String,
                                           parameters: [String: Any],
                                           interceptor: RequestInterceptor? = nil,
                                           responseType: D.Type,
                                           customError: E.Type,
                                           retryAttempts: Int? = nil,
                                           retryDelay: UInt32? = nil,
                                           retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
                                           progress: ((Double) -> Void)? = nil,
                                           completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     retryAttempts: retryAttempts ?? self.retryAttempts,
                                     retryDelay: retryDelay ?? self.retryDelay,
                                     retryAdapter: retryAdapter,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType,
                                    customError: customError))
        }
    }
}
