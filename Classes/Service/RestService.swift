import Foundation

/// A REST service object that can make requests to a server.
public class RestService {
    
    // MARK: - Dependencies
    
    let bodyBuilder = BodyBuilder()
    let interceptorBuilder = InterceptorBuilder()
    let pathBuilder = PathBuilder()
    let queryBuilder = QueryItemsBuilder()
    let requestBuilder = RequestBuilder()
    let taskBuilder = TaskBuilder()
    
    // MARK: - Properties
    
    /// URLSession instance for this service
    public var session: URLSession
    
    /// Scheme of the server URI
    public var scheme: HTTPScheme
    
    /// Host of the server URI
    public var host: String
    
    // Port of the server URI
    public var port: Int?
    
    /// Defines if the tasks should be executed automatically or not
    public var startTasksAutomatically = true
    
    // MARK: - Initialization
    
    /// Creates a new instance of the RestService
    ///
    /// - Parameters:
    ///   - session: URLSession instance for this service
    ///   - scheme: Scheme of the server URI
    ///   - host: Host of the server URI
    ///   - port: Port of the server URI
    public init(session: URLSession = URLSession.shared,
                scheme: HTTPScheme = .https,
                host: String,
                port: Int? = nil) {
        
        self.session = session
        self.scheme = scheme
        self.host = host
        self.port = port
    }
    
}

// MARK: - RestServiceProtocol
extension RestService: RestServiceProtocol {
    
    @discardableResult
    public func json(method: HTTPMethod,
                     path: String,
                     interceptor: RequestInterceptor?,
                     progress: ((Double) -> Void)?,
                     completion: @escaping (RestResponse) -> Void) -> RestDataTask? {
        
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
                     path: [RestPath],
                     interceptor: RequestInterceptor?,
                     progress: ((Double) -> Void)?,
                     completion: @escaping (RestResponse) -> Void) -> RestDataTask? {
        
        return json(method: method,
                    path: pathBuilder.build(path),
                    interceptor: interceptor,
                    progress: progress,
                    completion: completion)
    }
    
    @discardableResult
    public func json<T: Codable>(method: HTTPMethod,
                                 path: String,
                                 parameters: T,
                                 interceptor: RequestInterceptor?,
                                 progress: ((Double) -> Void)?,
                                 completion: @escaping (RestResponse) -> Void) -> RestDataTask? {
        
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
    public func json<T: Codable>(method: HTTPMethod,
                                 path: [RestPath],
                                 parameters: T,
                                 interceptor: RequestInterceptor?,
                                 progress: ((Double) -> Void)?,
                                 completion: @escaping (RestResponse) -> Void) -> RestDataTask? {
        return json(method: method,
                    path: pathBuilder.build(path),
                    parameters: parameters,
                    interceptor: interceptor,
                    progress: progress,
                    completion: completion)
    }
    
    @discardableResult
    public func json(method: HTTPMethod,
                     path: String,
                     parameters: [String: Any],
                     interceptor: RequestInterceptor?,
                     progress: ((Double) -> Void)?,
                     completion: @escaping (RestResponse) -> Void) -> RestDataTask? {
        
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
                     path: [RestPath],
                     parameters: [String: Any],
                     interceptor: RequestInterceptor?,
                     progress: ((Double) -> Void)?,
                     completion: @escaping (RestResponse) -> Void) -> RestDataTask? {
        return json(method: method,
                    path: pathBuilder.build(path),
                    parameters: parameters,
                    interceptor: interceptor,
                    progress: progress,
                    completion: completion)
    }
    
    @discardableResult
    public func formData(method: HTTPMethod,
                         path: String,
                         parameters: [FormDataParameter],
                         interceptor: RequestInterceptor?,
                         progress: ((Double) -> Void)?,
                         completion: @escaping (RestResponse) -> Void) -> RestDataTask? {
        
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
                         path: [RestPath],
                         parameters: [FormDataParameter],
                         interceptor: RequestInterceptor?,
                         progress: ((Double) -> Void)?,
                         completion: @escaping (RestResponse) -> Void) -> RestDataTask? {
        
        return formData(method: method,
                        path: pathBuilder.build(path),
                        parameters: parameters,
                        interceptor: interceptor,
                        progress: progress,
                        completion: completion)
    }
}
