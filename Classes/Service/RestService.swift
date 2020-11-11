import Foundation

open class RestService {
    
    // MARK: - Dependencies
    
    let bodyBuilder = BodyBuilder()
    let interceptorBuilder = InterceptorBuilder()
    let queryBuilder = QueryItemsBuilder()
    let requestBuilder = RequestBuilder()
    let taskBuilder = TaskBuilder()
    
    // MARK: - Properties
    
    public var session: URLSession
    public var debug: Bool
    public var scheme: HTTPScheme
    public var host: String
    public var port: Int?
    public var startTasksAutomatically: Bool
    
    // MARK: - Initialization
    
    public init(session: URLSession = URLSession.shared,
                debug: Bool = false,
                scheme: HTTPScheme = .https,
                host: String,
                port: Int? = nil,
                startTasksAutomatically: Bool = true) {
        
        self.session = session
        self.debug = debug
        self.scheme = scheme
        self.host = host
        self.port = port
        self.startTasksAutomatically = startTasksAutomatically
    }
}

// MARK: - Responses
extension RestService {
    
    func isValid(response: RestResponse) -> Bool {
        response.error == nil && 200..<300 ~= response.statusCode
    }
    
    func prepare(response: RestResponse) -> RestTaskResult {
        if isValid(response: response) {
            return .success
        }
        return .failure
    }
    
    func prepare<D: Decodable>(response: RestResponse,
                               responseType: D.Type) -> RestTaskResultWithData<D> {
        if let data = response.decodableValue(of: D.self) {
            return .success(data)
        }
        return .failure
    }
    
    func prepare<E: Decodable>(response: RestResponse,
                               customError: E.Type) -> RestTaskResultWithCustomError<E> {
        if let data = response.decodableValue(of: E.self) {
            return .customError(data)
        } else if isValid(response: response) {
            return .success
        }
        return .failure
    }
    
    func prepare<D: Decodable,
                 E: Decodable>(response: RestResponse,
                               responseType: D.Type,
                               customError: E.Type) -> RestTaskResultWithDataAndCustomError<D, E> {
        if let data = response.decodableValue(of: D.self) {
            return .success(data)
        } else if let data = response.decodableValue(of: E.self) {
            return .customError(data)
        }
        return .failure
    }
}
