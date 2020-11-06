import Foundation

class RestTask {
    
    let session: URLSession
    var dataTask: URLSessionDataTask?
    var observation: NSKeyValueObservation?
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    deinit {
        dataTask?.cancel()
        observation?.invalidate()
    }
    
    func request(request: URLRequest, progress: @escaping (Double) -> Void, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        cancel()
        dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard self != nil else { return }
            completion(data, response, error)
        }
        observation = dataTask?.progress.observe(\.fractionCompleted) { [weak self] taskProgress, _ in
            guard self != nil else { return }
            progress(taskProgress.fractionCompleted)
        }
    }
}

extension RestTask: RestDataTask {
    
    func suspend() {
        dataTask?.suspend()
    }
    
    func resume() {
        dataTask?.resume()
    }
    
    func cancel() {
        dataTask?.cancel()
        observation?.invalidate()
    }
}
