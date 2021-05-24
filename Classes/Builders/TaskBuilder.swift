import Foundation

struct TaskBuilder {
    
    func build(session: URLSession,
               decoder: JSONDecoder = JSONDecoder(),
               debug: Bool = false,
               request: URLRequest,
               autoResume: Bool,
               retryAttempts: Int = 0,
               retryDelay: UInt32 = 0,
               retryAdapter: ((URLRequest, Int) -> URLRequest)? = nil,
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
            retryAdapter: { request, retryAttempts in
                retryAdapter?(request, retryAttempts) ?? request
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
