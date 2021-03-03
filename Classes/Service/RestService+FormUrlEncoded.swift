import Foundation

// MARK: - Form Url Encoded Without Parameters
extension RestService {
    
    // MARK: Prepare
    
    func prepareFormUrlEncoded(debug: Bool? = nil,
                               method: HTTPMethod,
                               path: String,
                               interceptor: RequestInterceptor?,
                               progress: ((Double) -> Void)?,
                               completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: fullPath(with: path),
                queryItems: nil,
                body: nil,
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
            progress: progress,
            completion: completion
        )
    }
    
    // MARK: Simple
    
    @discardableResult
    public func formUrlEncoded(debug: Bool? = nil,
                               method: HTTPMethod,
                               path: String,
                               interceptor: RequestInterceptor?,
                               progress: ((Double) -> Void)?,
                               completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     interceptor: interceptor,
                                     progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    @discardableResult
    public func formUrlEncoded(debug: Bool? = nil,
                               method: HTTPMethod,
                               path: String,
                               interceptor: RequestInterceptor?,
                               completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              interceptor: interceptor,
                              progress: nil,
                              completion: completion)
    }
    
    // MARK: With Response Type
    
    @discardableResult
    public func formUrlEncoded<D: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             progress: ((Double) -> Void)?,
                                             completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     interceptor: interceptor,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType))
        }
    }
    
    @discardableResult
    public func formUrlEncoded<D: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              interceptor: interceptor,
                              responseType: responseType,
                              progress: nil,
                              completion: completion)
    }
    
    // MARK: With Custom Error
    
    @discardableResult
    public func formUrlEncoded<E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             interceptor: RequestInterceptor?,
                                             customError: E.Type,
                                             progress: ((Double) -> Void)?,
                                             completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     interceptor: interceptor,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    customError: customError))
        }
    }
    
    @discardableResult
    public func formUrlEncoded<E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             interceptor: RequestInterceptor?,
                                             customError: E.Type,
                                             completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              interceptor: interceptor,
                              customError: customError,
                              progress: nil,
                              completion: completion)
    }
    
    // MARK: With Response Type and Custom Error
    
    @discardableResult
    public func formUrlEncoded<D: Decodable,
                               E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             customError: E.Type,
                                             progress: ((Double) -> Void)?,
                                             completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
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
    public func formUrlEncoded<D: Decodable,
                               E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             customError: E.Type,
                                             completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              interceptor: interceptor,
                              responseType: responseType,
                              customError: customError,
                              progress: nil,
                              completion: completion)
    }
}

// MARK: - Form Url Encoded With Codable Parameters
extension RestService {
    
    // MARK: Prepare
    
    func prepareFormUrlEncoded<P: Codable>(debug: Bool? = nil,
                                           method: HTTPMethod,
                                           path: String,
                                           parameters: P,
                                           interceptor: RequestInterceptor?,
                                           progress: ((Double) -> Void)?,
                                           completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: fullPath(with: path),
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
            progress: progress,
            completion: completion
        )
    }
    
    // MARK: Simple
    
    @discardableResult
    public func formUrlEncoded<P: Codable>(debug: Bool? = nil,
                                           method: HTTPMethod,
                                           path: String,
                                           parameters: P,
                                           interceptor: RequestInterceptor?,
                                           progress: ((Double) -> Void)?,
                                           completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    @discardableResult
    public func formUrlEncoded<P: Codable>(debug: Bool? = nil,
                                           method: HTTPMethod,
                                           path: String,
                                           parameters: P,
                                           interceptor: RequestInterceptor?,
                                           completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              parameters: parameters,
                              interceptor: interceptor,
                              progress: nil,
                              completion: completion)
    }
    
    // MARK: With Response Type
    
    @discardableResult
    public func formUrlEncoded<P: Codable,
                               D: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: P,
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             progress: ((Double) -> Void)?,
                                             completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType))
        }
    }
    
    @discardableResult
    public func formUrlEncoded<P: Codable,
                               D: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: P,
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              parameters: parameters,
                              interceptor: interceptor,
                              responseType: responseType,
                              progress: nil,
                              completion: completion)
    }
    
    // MARK: With Custom Error
    
    @discardableResult
    public func formUrlEncoded<P: Codable,
                               E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: P,
                                             interceptor: RequestInterceptor?,
                                             customError: E.Type,
                                             progress: ((Double) -> Void)?,
                                             completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    customError: customError))
        }
    }
    
    @discardableResult
    public func formUrlEncoded<P: Codable,
                               E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: P,
                                             interceptor: RequestInterceptor?,
                                             customError: E.Type,
                                             completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              parameters: parameters,
                              interceptor: interceptor,
                              customError: customError,
                              progress: nil,
                              completion: completion)
    }
    
    // MARK: With Response Type and Custom Error
    
    @discardableResult
    public func formUrlEncoded<P: Codable,
                               D: Decodable,
                               E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: P,
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             customError: E.Type,
                                             progress: ((Double) -> Void)?,
                                             completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
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
    
    @discardableResult
    public func formUrlEncoded<P: Codable,
                               D: Decodable,
                               E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: P,
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             customError: E.Type,
                                             completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              parameters: parameters,
                              interceptor: interceptor,
                              responseType: responseType,
                              customError: customError,
                              progress: nil,
                              completion: completion)
    }
}

// MARK: - Form Url Encoded With Dictionary Parameters
extension RestService {
    
    // MARK: Prepare
    
    func prepareFormUrlEncoded(debug: Bool? = nil,
                               method: HTTPMethod,
                               path: String,
                               parameters: [String: Any],
                               interceptor: RequestInterceptor?,
                               progress: ((Double) -> Void)?,
                               completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        guard let request = requestBuilder.build(
                scheme: scheme,
                method: method,
                host: host,
                path: fullPath(with: path),
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
            progress: progress,
            completion: completion
        )
    }
    
    // MARK: Simple
    
    @discardableResult
    public func formUrlEncoded(debug: Bool? = nil,
                               method: HTTPMethod,
                               path: String,
                               parameters: [String: Any],
                               interceptor: RequestInterceptor?,
                               progress: ((Double) -> Void)?,
                               completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     progress: progress) { response in
            completion(self.prepare(response: response))
        }
    }
    
    @discardableResult
    public func formUrlEncoded(debug: Bool? = nil,
                               method: HTTPMethod,
                               path: String,
                               parameters: [String: Any],
                               interceptor: RequestInterceptor?,
                               completion: @escaping (RestTaskResult) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              parameters: parameters,
                              interceptor: interceptor,
                              progress: nil,
                              completion: completion)
    }
    
    // MARK: With Response Type
    
    @discardableResult
    public func formUrlEncoded<D: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: [String: Any],
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             progress: ((Double) -> Void)?,
                                             completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    responseType: responseType))
        }
    }
    
    @discardableResult
    public func formUrlEncoded<D: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: [String: Any],
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             completion: @escaping (RestTaskResultWithData<D>) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              parameters: parameters,
                              interceptor: interceptor,
                              responseType: responseType,
                              progress: nil,
                              completion: completion)
    }
    
    // MARK: With Custom Error
    
    @discardableResult
    public func formUrlEncoded<E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: [String: Any],
                                             interceptor: RequestInterceptor?,
                                             customError: E.Type,
                                             progress: ((Double) -> Void)?,
                                             completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
                                     method: method,
                                     path: path,
                                     parameters: parameters,
                                     interceptor: interceptor,
                                     progress: progress) { response in
            completion(self.prepare(response: response,
                                    customError: customError))
        }
    }
    
    @discardableResult
    public func formUrlEncoded<E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: [String: Any],
                                             interceptor: RequestInterceptor?,
                                             customError: E.Type,
                                             completion: @escaping (RestTaskResultWithCustomError<E>) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              parameters: parameters,
                              interceptor: interceptor,
                              customError: customError,
                              progress: nil,
                              completion: completion)
    }
    
    // MARK: With Response Type and Custom Error
    
    @discardableResult
    public func formUrlEncoded<D: Decodable,
                               E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: [String: Any],
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             customError: E.Type,
                                             progress: ((Double) -> Void)?,
                                             completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return prepareFormUrlEncoded(debug: debug,
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
    
    @discardableResult
    public func formUrlEncoded<D: Decodable,
                               E: Decodable>(debug: Bool? = nil,
                                             method: HTTPMethod,
                                             path: String,
                                             parameters: [String: Any],
                                             interceptor: RequestInterceptor?,
                                             responseType: D.Type,
                                             customError: E.Type,
                                             completion: @escaping (RestTaskResultWithDataAndCustomError<D, E>) -> Void) -> RestTask? {
        
        return formUrlEncoded(debug: debug,
                              method: method,
                              path: path,
                              parameters: parameters,
                              interceptor: interceptor,
                              responseType: responseType,
                              customError: customError,
                              progress: nil,
                              completion: completion)
    }
}
