import Foundation

open class RestService {
    
    // MARK: - Dependencies
    
    var bodyBuilder = BodyBuilder()
    var interceptorBuilder = InterceptorBuilder()
    var queryBuilder = QueryItemsBuilder()
    var requestBuilder = RequestBuilder()
    var taskBuilder = TaskBuilder()
    
    // MARK: - Properties
    
    public var session: URLSession
    public var encoder: JSONEncoder {
        didSet {
            bodyBuilder.encoder = encoder
            queryBuilder.encoder = encoder
        }
    }
    public var decoder: JSONDecoder
    public var debug: Bool
    public var scheme: HTTPScheme
    public var host: String
    public var port: Int?
    public var basePath: String?
    public var startTasksAutomatically: Bool
    
    // MARK: - Initialization
    
    public init(session: URLSession = URLSession.shared,
                encoder: JSONEncoder = JSONEncoder(),
                decoder: JSONDecoder = JSONDecoder(),
                debug: Bool = false,
                scheme: HTTPScheme = .https,
                host: String,
                port: Int? = nil,
                basePath: String? = nil,
                startTasksAutomatically: Bool = true) {
        
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
        self.debug = debug
        self.scheme = scheme
        self.host = host
        self.port = port
        self.basePath = basePath
        self.startTasksAutomatically = startTasksAutomatically
        
        bodyBuilder.encoder = encoder
        queryBuilder.encoder = encoder
    }
    
    public convenience init(session: URLSession = URLSession.shared,
                            encoder: JSONEncoder = JSONEncoder(),
                            decoder: JSONDecoder = JSONDecoder(),
                            debug: Bool = false,
                            url: URL?,
                            resolvingAgainstBaseURL: Bool = true,
                            startTasksAutomatically: Bool = true) {
        
        if let url = url,
           let components = URLComponents(url: url, resolvingAgainstBaseURL: resolvingAgainstBaseURL),
           let host = components.host {
            self.init(session: session,
                      encoder: encoder,
                      decoder: decoder,
                      debug: debug,
                      scheme: HTTPScheme(rawValue: components.scheme ?? "https"),
                      host: host,
                      port: components.port,
                      basePath: components.path,
                      startTasksAutomatically: startTasksAutomatically)
        } else {
            self.init(session: session,
                      encoder: encoder,
                      decoder: decoder,
                      debug: debug,
                      host: "",
                      startTasksAutomatically: startTasksAutomatically)
        }
    }
    
    public convenience init(session: URLSession = URLSession.shared,
                            encoder: JSONEncoder = JSONEncoder(),
                            decoder: JSONDecoder = JSONDecoder(),
                            debug: Bool = false,
                            url: String,
                            startTasksAutomatically: Bool = true) {
        
        if let urlFromString = URL(string: url) {
            self.init(session: session,
                      encoder: encoder,
                      decoder: decoder,
                      debug: debug,
                      url: urlFromString,
                      startTasksAutomatically: startTasksAutomatically)
        } else {
            self.init(session: session,
                      encoder: encoder,
                      decoder: decoder,
                      debug: debug,
                      host: "",
                      startTasksAutomatically: startTasksAutomatically)
        }
    }
}

// MARK: - Path
extension RestService {
    
    func fullPath(with path: String) -> String {
        if let basePath = self.basePath {
            return basePath + path
        }
        return path
    }
}

// MARK: - Responses
extension RestService {
    
    func convert<D: Decodable>(response: RestResponse, to type: D.Type) -> D? {
        if type == Int.self, let str = response.stringValue(), let data = Int(str) as? D {
            return data
        }
        if type == Float.self, let str = response.stringValue(), let data = Float(str) as? D {
            return data
        }
        if type == Double.self, let str = response.stringValue(), let data = Double(str) as? D {
            return data
        }
        if type == String.self, let data = response.stringValue() as? D {
            return data
        }
        if type == Data.self, let data = response.data as? D {
            return data
        }
        return nil
    }
    
    func prepare(response: RestResponse) -> RestTaskResult {
        if let error = response.error {
            return .failure(error)
        }
        if response.statusCode < 400 {
            return .success
        }
        if response.data != nil {
            return .failure(RestServiceError.unknown)
        }
        return .failure(RestServiceError.noData)
    }
    
    func prepare<D: Decodable>(response: RestResponse,
                               responseType: D.Type) -> RestTaskResultWithData<D> {
        if let error = response.error {
            return .failure(error)
        }
        if response.statusCode < 400 {
            if let data = convert(response: response, to: responseType) {
                return .success(data)
            }
            if let data = response.data {
                do {
                    let result = try decoder.decode(D.self, from: data)
                    return .success(result)
                } catch (let error) {
                    return .failure(error)
                }
            }
            return .failure(RestServiceError.noData)
        }
        if response.data != nil {
            return .failure(RestServiceError.unknown)
        }
        return .failure(RestServiceError.noData)
    }
    
    func prepare<E: Decodable & Error>(response: RestResponse,
                                       customError: E.Type) -> RestTaskResultWithCustomError<E> {
        if let error = response.error {
            return .failure(error)
        }
        if response.statusCode < 400 {
            if let data = response.data, let result = try? decoder.decode(E.self, from: data) {
                return .customError(result)
            }
            return .success
        }
        if let data = response.data {
            do {
                let customResult = try decoder.decode(E.self, from: data)
                return .customError(customResult)
            } catch (let error) {
                return .failure(error)
            }
        }
        return .failure(RestServiceError.noData)
    }
    
    func prepare<D: Decodable,
                 E: Decodable & Error>(response: RestResponse,
                                       responseType: D.Type,
                                       customError: E.Type) -> RestTaskResultWithDataAndCustomError<D, E> {
        if let error = response.error {
            return .failure(error)
        }
        if response.statusCode < 400 {
            if let data = convert(response: response, to: responseType) {
                return .success(data)
            }
            if let data = response.data {
                do {
                    let result = try decoder.decode(D.self, from: data)
                    return .success(result)
                } catch (let error) {
                    do {
                        let customResult = try decoder.decode(E.self, from: data)
                        return .customError(customResult)
                    } catch (_) {
                        return .failure(error)
                    }
                }
            }
            return .failure(RestServiceError.noData)
        }
        if let data = response.data {
            do {
                let customResult = try decoder.decode(E.self, from: data)
                return .customError(customResult)
            } catch (let error) {
                return .failure(error)
            }
        }
        return .failure(RestServiceError.noData)
    }
}
