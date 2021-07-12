import Foundation

struct TaskBuilder {
    
    func build(session: URLSession,
               decoder: JSONDecoder = JSONDecoder(),
               debug: Bool = false,
               request: URLRequest,
               autoResume: Bool,
               retryAttempts: Int = 0,
               retryDelay: UInt32 = 0,
               retryAdapter: ((URLRequest, Int, URLResponse?) -> URLRequest?)? = nil,
               progress: ((Double) -> Void)? = nil,
               completion: @escaping (RestResponse) -> Void) -> RestTask? {
        
        let task = RestTask(
            session: session,
            decoder: decoder,
            retryAttempts: retryAttempts,
            retryDelay: retryDelay,
            debug: debug
        )
        task.prepare(
            request: request,
            autoResume: autoResume,
            retryAdapter: { request, retryAttempts, response in
                retryAdapter?(request, retryAttempts, response) ?? request
            },
            progress: { progressValue in
                progress?(progressValue)
            },
            completion: { response in
                completion(response)
            }
        )
        return task
    }
}
