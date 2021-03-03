import Foundation

struct TaskBuilder {
    
    func build(session: URLSession,
               decoder: JSONDecoder = JSONDecoder(),
               debug: Bool = false,
               request: URLRequest,
               autoResume: Bool,
               progress: ((Double) -> Void)? = nil,
               completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        let task = RestTask(
            session: session,
            decoder: decoder,
            debug: debug
        )
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
