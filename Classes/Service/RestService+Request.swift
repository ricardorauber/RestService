import Foundation

// MARK: - REQUEST Without Body
extension RestService {
    
    // MARK: Prepare
    
    func prepareRequest(debug: Bool? = nil,
                        method: HTTPMethod,
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
                interceptor: interceptor)
        else {
            return nil
        }
        return taskBuilder.build(
            session: session,
            debug: debug ?? self.debug,
            request: request,
            autoResume: startTasksAutomatically,
            progress: progress,
            completion: completion
        )
    }
    
    // MARK: Simple
    
    @discardableResult
    public func request(debug: Bool? = nil,
                        method: HTTPMethod,
                        path: String,
                        interceptor: RequestInterceptor?,
                        progress: ((Double) -> Void)?,
                        completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareRequest(debug: debug,
                              method: method,
                              path: path,
                              interceptor: interceptor,
                              progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    @discardableResult
    public func request(debug: Bool? = nil,
                        method: HTTPMethod,
                        path: String,
                        interceptor: RequestInterceptor?,
                        completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return request(debug: debug,
                       method: method,
                       path: path,
                       interceptor: interceptor,
                       progress: nil,
                       completion: completion)
    }
    
    // MARK: With Response Type
    
    @discardableResult
    public func request<D: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      interceptor: RequestInterceptor?,
                                      responseType: D.Type,
                                      progress: ((Double) -> Void)?,
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
    
    @discardableResult
    public func request<D: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      interceptor: RequestInterceptor?,
                                      responseType: D.Type,
                                      completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return request(debug: debug,
                       method: method,
                       path: path,
                       interceptor: interceptor,
                       responseType: responseType,
                       progress: nil,
                       completion: completion)
    }
    
    // MARK: With Custom Error
    
    @discardableResult
    public func request<E: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      interceptor: RequestInterceptor?,
                                      customError: E.Type,
                                      progress: ((Double) -> Void)?,
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
    
    @discardableResult
    public func request<E: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      interceptor: RequestInterceptor?,
                                      customError: E.Type,
                                      completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return request(debug: debug,
                       method: method,
                       path: path,
                       interceptor: interceptor,
                       customError: customError,
                       progress: nil,
                       completion: completion)
    }
    
    // MARK: With Response Type and Custom Error
    
    @discardableResult
    public func request<D: Decodable,
                        E: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      interceptor: RequestInterceptor?,
                                      responseType: D.Type,
                                      customError: E.Type,
                                      progress: ((Double) -> Void)?,
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
    
    @discardableResult
    public func request<D: Decodable,
                        E: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      interceptor: RequestInterceptor?,
                                      responseType: D.Type,
                                      customError: E.Type,
                                      completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return request(debug: debug,
                       method: method,
                       path: path,
                       interceptor: interceptor,
                       responseType: responseType,
                       customError: customError,
                       progress: nil,
                       completion: completion)
    }
}

// MARK: - REQUEST With Body
extension RestService {
    
    // MARK: Prepare
    
    func prepareRequest(debug: Bool? = nil,
                        method: HTTPMethod,
                        path: String,
                        body: Data,
                        interceptor: RequestInterceptor?,
                        progress: ((Double) -> Void)?,
                        completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: path,
                queryItems: nil,
                body: body,
                interceptor: interceptor)
        else {
            return nil
        }
        return taskBuilder.build(
            session: session,
            debug: debug ?? self.debug,
            request: request,
            autoResume: startTasksAutomatically,
            progress: progress,
            completion: completion
        )
    }
    
    // MARK: Simple
    
    @discardableResult
    public func request(debug: Bool? = nil,
                        method: HTTPMethod,
                        path: String,
                        body: Data,
                        interceptor: RequestInterceptor?,
                        progress: ((Double) -> Void)?,
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
    
    @discardableResult
    public func request(debug: Bool? = nil,
                        method: HTTPMethod,
                        path: String,
                        body: Data,
                        interceptor: RequestInterceptor?,
                        completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return request(debug: debug,
                       method: method,
                       path: path,
                       body: body,
                       interceptor: interceptor,
                       progress: nil,
                       completion: completion)
    }
    
    // MARK: With Response Type
    
    @discardableResult
    public func request<D: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      body: Data,
                                      interceptor: RequestInterceptor?,
                                      responseType: D.Type,
                                      progress: ((Double) -> Void)?,
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
    
    @discardableResult
    public func request<D: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      body: Data,
                                      interceptor: RequestInterceptor?,
                                      responseType: D.Type,
                                      completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return request(debug: debug,
                       method: method,
                       path: path,
                       body: body,
                       interceptor: interceptor,
                       responseType: responseType,
                       progress: nil,
                       completion: completion)
    }
    
    // MARK: With Custom Error
    
    @discardableResult
    public func request<E: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      body: Data,
                                      interceptor: RequestInterceptor?,
                                      customError: E.Type,
                                      progress: ((Double) -> Void)?,
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
    
    @discardableResult
    public func request<E: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      body: Data,
                                      interceptor: RequestInterceptor?,
                                      customError: E.Type,
                                      completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return request(debug: debug,
                       method: method,
                       path: path,
                       body: body,
                       interceptor: interceptor,
                       customError: customError,
                       progress: nil,
                       completion: completion)
    }
    
    // MARK: With Response Type and Custom Error
    
    @discardableResult
    public func request<D: Decodable,
                        E: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      body: Data,
                                      interceptor: RequestInterceptor?,
                                      responseType: D.Type,
                                      customError: E.Type,
                                      progress: ((Double) -> Void)?,
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
    
    @discardableResult
    public func request<D: Decodable,
                        E: Decodable>(debug: Bool? = nil,
                                      method: HTTPMethod,
                                      path: String,
                                      body: Data,
                                      interceptor: RequestInterceptor?,
                                      responseType: D.Type,
                                      customError: E.Type,
                                      completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return request(debug: debug,
                       method: method,
                       path: path,
                       body: body,
                       interceptor: interceptor,
                       responseType: responseType,
                       customError: customError,
                       progress: nil,
                       completion: completion)
    }
}
