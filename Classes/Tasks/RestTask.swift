import Foundation

open class RestTask {
    
    // MARK: - Properties
    
    public var session: URLSession
    public var decoder: JSONDecoder
    public var retryAttempts: Int
    public var retryDelay: UInt32
    public var debug: Bool
    public private(set) var dataTask: URLSessionDataTask?
    public private(set) var request: URLRequest?
    public private(set) var response: RestResponse?
    var observation: NSKeyValueObservation?
    
    // MARK: - Initialization
    
    public init(session: URLSession = .shared,
                decoder: JSONDecoder = JSONDecoder(),
                retryAttempts: Int = 0,
                retryDelay: UInt32 = 0,
                debug: Bool = false) {
        
        self.session = session
        self.decoder = decoder
        self.retryAttempts = retryAttempts
        self.retryDelay = retryDelay
        self.debug = debug
    }
    
    deinit {
        observation?.invalidate()
    }
    
    // MARK: - Request Execution
    
    open func prepare(request: URLRequest,
                      autoResume: Bool,
                      retryAdapter: @escaping (URLRequest, Int, URLResponse?) -> URLRequest?,
                      progress: @escaping (Double) -> Void,
                      completion: @escaping (RestResponse) -> Void) {
        cancel()
        self.request = request
        dataTask = session.dataTask(with: request) { data, response, error in
            let restResponse = RestResponse(
                decoder: self.decoder,
                data: data,
                request: request,
                response: response,
                error: error
            )
            self.response = restResponse
            if self.debug {
                self.log(response: restResponse)
            }
            if (error != nil || restResponse.statusCode >= 400) && self.retryAttempts > 0 {
                if self.debug {
                    self.log(retryAttempts: self.retryAttempts)
                }
                self.retryAttempts -= 1
                sleep(self.retryDelay)
                guard let adaptedRequest = retryAdapter(request, self.retryAttempts, response) else {
                    return
                }
                self.prepare(
                    request: adaptedRequest,
                    autoResume: true,
                    retryAdapter: retryAdapter,
                    progress: progress,
                    completion: completion
                )
                return
            }
            completion(restResponse)
        }
        observation = dataTask?.progress.observe(\.fractionCompleted) { taskProgress, _ in
            progress(taskProgress.fractionCompleted)
        }
        if autoResume {
            dataTask?.resume()
        }
    }
    
    open func suspend() {
        dataTask?.suspend()
    }
    
    open func resume() {
        dataTask?.resume()
    }
    
    open func cancel() {
        dataTask?.cancel()
        observation?.invalidate()
    }
    
    // MARK: - Request Debug Log
    
    func log(response: RestResponse) {
        print("==============================================")
        log(request: response.request)
        log(headers: response.request?.allHTTPHeaderFields)
        log(body: response.request?.httpBody)
        log(httpResponse: response)
        log(headers: response.headers)
        log(body: response.data)
        print("------------------------------")
    }
    
    func log(request: URLRequest?) {
        let method = request?.httpMethod
        let url = request?.url?.absoluteString
        print(" ⚪️ REQUEST: " + (method ?? "-") + " " + (url ?? "-"), "\n")
    }
    
    func log(httpResponse: RestResponse) {
        var icon = "🟢"
        if httpResponse.error != nil {
            icon = "🔴"
        } else if httpResponse.statusCode >= 300 {
            icon = "🟡"
        }
        print(" " + icon + " RESPONSE: \(httpResponse.statusCode)", "\n")
    }
    
    func log(headers: [AnyHashable: Any]?) {
        var description = "nil"
        if let headers = headers {
            description = descriptionFrom(dictionary: headers)
        }
        print("> Headers:")
        print(description, "\n")
    }
    
    func log(body: Data?) {
        var description = "nil"
        if let body = body {
            if let dictionary = try? JSONSerialization.jsonObject(with: body, options: .mutableLeaves) as? [String: Any] {
                description = descriptionFrom(dictionary: dictionary)
            } else if let stringDescription = String(data: body, encoding: .utf8) {
                description = stringDescription
            }
        }
        print("> Body:")
        print(description, "\n")
    }
    
    func descriptionFrom(dictionary: [AnyHashable: Any]) -> String {
        var description = "[\n"
        for (key, value) in dictionary {
            description += "    \"" + String(describing: key) + "\": \"" + String(describing: value) + "\",\n"
        }
        description = String(String(description.dropLast()).dropLast()) + "\n]"
        return description
    }
    
    func log(retryAttempts: Int) {
        print("> Retrying request: \(retryAttempts) attempts left.")
        print("-----")
    }
}
