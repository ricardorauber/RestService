import Foundation

public class RestTask {
    
    // MARK: - Properties
    
    public var session: URLSession
    public private(set) var dataTask: URLSessionDataTask?
    public private(set) var request: URLRequest?
    public private(set) var response: RestResponse?
    var observation: NSKeyValueObservation?
    
    // MARK: - Initialization
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Request Execution
    
    public func prepare(request: URLRequest,
                        progress: @escaping (Double) -> Void,
                        completion: @escaping (RestResponse) -> Void) {
        cancel()
        dataTask = session.dataTask(with: request) { data, response, error in
            let response = RestResponse(data: data, request: request, response: response, error: error)
            self.response = response
            completion(response)
        }
        observation = dataTask?.progress.observe(\.fractionCompleted) { taskProgress, _ in
            progress(taskProgress.fractionCompleted)
        }
    }
    
    public func suspend() {
        dataTask?.suspend()
    }
    
    public func resume() {
        dataTask?.resume()
    }
    
    public func cancel() {
        dataTask?.cancel()
        observation?.invalidate()
    }
}
