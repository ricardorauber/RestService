import Foundation

struct TaskBuilder {
    
    func build(session: URLSession,
               request: URLRequest,
               autoResume: Bool,
               progress: ((Double) -> Void)?,
               completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        let task = RestTask(session: session)
        task.prepare(
            request: request,
            progress: { progressValue in
                progress?(progressValue)
            },
            completion: { response in
                completion(response)
            }
        )
        if autoResume {
            task.resume()
        }
        return task
    }
}
