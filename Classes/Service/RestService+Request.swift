import Foundation

// MARK: - REQUEST Without Body
extension RestService {
    
    // MARK: Prepare
    
    func prepareRequest(debug: Bool? = nil,
                        method: HTTPMethod,
                        path: String,
                        interceptor: RequestInterceptor? = nil,
                        progress: ((Double) -> Void)? = nil,
                        completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: fullPath(with: path),
                interceptor: interceptor)
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
    open func request(debug: Bool? = nil,
                      method: HTTPMethod,
                      path: String,
                      interceptor: RequestInterceptor? = nil,
                      progress: ((Double) -> Void)? = nil,
                      completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareRequest(debug: debug,
                              method: method,
                              path: path,
                              interceptor: interceptor,
                              progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    // MARK: With Response Type
    
    @discardableResult
    open func request<D: Decodable>(debug: Bool? = nil,
                                    method: HTTPMethod,
                                    path: String,
                                    interceptor: RequestInterceptor? = nil,
                                    responseType: D.Type,
                                    progress: ((Double) -> Void)? = nil,
                                    completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareRequest(debug: debug,
                              method: method,
                              path: path,
                              interceptor: interceptor,
                              progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType))
        }
    }
    
    // MARK: With Custom Error
    
    @discardableResult
    open func request<E: Decodable & Error>(debug: Bool? = nil,
                                            method: HTTPMethod,
                                            path: String,
                                            interceptor: RequestInterceptor? = nil,
                                            customError: E.Type,
                                            progress: ((Double) -> Void)? = nil,
                                            completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareRequest(debug: debug,
                              method: method,
                              path: path,
                              interceptor: interceptor,
                              progress: progress) { response in
            completion(self.prepare(response: response,
                                    customError: customError))
        }
    }
    
    // MARK: With Response Type and Custom Error
    
    @discardableResult
    open func request<D: Decodable,
                      E: Decodable>(debug: Bool? = nil,
                                    method: HTTPMethod,
                                    path: String,
                                    interceptor: RequestInterceptor? = nil,
                                    responseType: D.Type,
                                    customError: E.Type,
                                    progress: ((Double) -> Void)? = nil,
                                    completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareRequest(debug: debug,
                              method: method,
                              path: path,
                              interceptor: interceptor,
                              progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType,
                                    customError: customError))
        }
    }
}

// MARK: - REQUEST With Body
extension RestService {
    
    // MARK: Prepare
    
    func prepareRequest(debug: Bool? = nil,
                        method: HTTPMethod,
                        path: String,
                        body: Data,
                        interceptor: RequestInterceptor? = nil,
                        progress: ((Double) -> Void)? = nil,
                        completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: fullPath(with: path),
                body: body,
                interceptor: interceptor)
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
    open func request(debug: Bool? = nil,
                      method: HTTPMethod,
                      path: String,
                      body: Data,
                      interceptor: RequestInterceptor? = nil,
                      progress: ((Double) -> Void)? = nil,
                      completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareRequest(debug: debug,
                              method: method,
                              path: path,
                              body: body,
                              interceptor: interceptor,
                              progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    // MARK: With Response Type
    
    @discardableResult
    open func request<D: Decodable>(debug: Bool? = nil,
                                    method: HTTPMethod,
                                    path: String,
                                    body: Data,
                                    interceptor: RequestInterceptor? = nil,
                                    responseType: D.Type,
                                    progress: ((Double) -> Void)? = nil,
                                    completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareRequest(debug: debug,
                              method: method,
                              path: path,
                              body: body,
                              interceptor: interceptor,
                              progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType))
        }
    }
    
    // MARK: With Custom Error
    
    @discardableResult
    open func request<E: Decodable & Error>(debug: Bool? = nil,
                                            method: HTTPMethod,
                                            path: String,
                                            body: Data,
                                            interceptor: RequestInterceptor? = nil,
                                            customError: E.Type,
                                            progress: ((Double) -> Void)? = nil,
                                            completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareRequest(debug: debug,
                              method: method,
                              path: path,
                              body: body,
                              interceptor: interceptor,
                              progress: progress) { response in
            completion(self.prepare(response: response,
                                    customError: customError))
        }
    }
    
    // MARK: With Response Type and Custom Error
    
    @discardableResult
    open func request<D: Decodable,
                      E: Decodable>(debug: Bool? = nil,
                                    method: HTTPMethod,
                                    path: String,
                                    body: Data,
                                    interceptor: RequestInterceptor? = nil,
                                    responseType: D.Type,
                                    customError: E.Type,
                                    progress: ((Double) -> Void)? = nil,
                                    completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareRequest(debug: debug,
                              method: method,
                              path: path,
                              body: body,
                              interceptor: interceptor,
                              progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType,
                                    customError: customError))
        }
    }
}
