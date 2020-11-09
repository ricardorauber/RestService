import Foundation

public class RestTask {
    
    // MARK: - Properties
    
    let session: URLSession
    var dataTask: URLSessionDataTask?
    var observation: NSKeyValueObservation?
    var request: URLRequest?
    var response: RestResponse?
    
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
