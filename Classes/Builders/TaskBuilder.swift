import Foundation

class TaskBuilder {
    
    func build(session: URLSession,
               request: URLRequest,
               autoResume: Bool,
               progress: ((Double) -> Void)?,
               completion: @escaping (RestResponse) -> Void) -> RestDataTask? {
        
        let task = RestTask(session: session)
        task.request(
            request: request,
            progress: { [weak self] progressValue in
                guard self != nil else { return }
                progress?(progressValue)
            },
            completion: { [weak self] data, response, error in
                guard self != nil else { return }
                completion(RestResponse(data: data, request: request, response: response, error: error))
            }
        )
        if autoResume {
            task.resume()
        }
        return task
    }
}
