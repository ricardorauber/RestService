import Foundation

struct TaskBuilder {
    
    func build(session: URLSession,
               debug: Bool = false,
               request: URLRequest,
               autoResume: Bool,
               progress: ((Double) -> Void)?,
               completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        let task = RestTask(session: session, debug: debug)
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
