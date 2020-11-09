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
    public var scheme: HTTPScheme
    public var host: String
    public var port: Int?
    public var startTasksAutomatically = true
    
    // MARK: - Initialization
    
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

// MARK: - Responses
extension RestService {
    
    func isValid(response: RestResponse) -> Bool {
        response.error == nil && 200..<300 ~= response.statusCode
    }
    
    func prepare(response: RestResponse) -> RestTaskResult {
        if isValid(response: response) {
            return .success
        } else {
            return .failure
        }
    }
    
    func prepare<D: Decodable>(response: RestResponse,
                               responseType: D.Type) -> RestTaskResultWithData<D> {
        if let data = response.decodableValue(of: D.self) {
            return .success(data)
        } else {
            return .failure
        }
    }
    
    func prepare<E: Decodable>(response: RestResponse,
                               customError: E.Type) -> RestTaskResultWithCustomError<E> {
        if let data = response.decodableValue(of: E.self) {
            return .customError(data)
        } else if isValid(response: response) {
            return .success
        } else {
            return .failure
        }
    }
    
    func prepare<D: Decodable,
                 E: Decodable>(response: RestResponse,
                               responseType: D.Type,
                               customError: E.Type) -> RestTaskResultWithDataAndCustomError<D, E> {
        if let data = response.decodableValue(of: D.self) {
            return .success(data)
        } else if let data = response.decodableValue(of: E.self) {
            return .customError(data)
        } else {
            return .failure
        }
    }
}
