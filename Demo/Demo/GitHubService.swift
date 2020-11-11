import RestService

class GitHubService {
    
    let service: RestService
    
    init(service: RestService) {
        self.service = service
    }
    
    func findUsers(name: String, callback: @escaping ([User]) -> Void) -> RestTask? {
        struct FindUserParameters: Codable {
            let q: String
        }
        return service.json(
            method: .get,
            path: "/search/users",
            parameters: FindUserParameters(q: name),
            interceptor: nil,
            responseType: UserList.self,
            progress: nil) { [weak self] response in
            
            guard self != nil else { return }
            switch response {
            case .success(let userList):
                callback(userList.users)
            default:
                break
            }
            
        }
    }
    
    func loadRepos(user: String, callback: @escaping ([Repository]) -> Void) -> RestTask? {
        let path = "/users/\(user)/repos"
        return service.json(
            method: .get,
            path: path,
            interceptor: nil,
            responseType: [Repository].self,
            progress: nil) { [weak self] response in
            
            guard self != nil else { return }
            switch response {
            case .success(var repositories):
                repositories = repositories.filter { $0.description != nil }
                callback(repositories)
            default:
                break
            }
        }
    }
}
