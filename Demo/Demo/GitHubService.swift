import RestService

class GitHubService {
	
	let service: RestService
	
	init(service: RestService) {
		self.service = service
	}
	
	func findUsers(name: String, callback: @escaping ([User]) -> Void) -> RestDataTask? {
		struct FindUserParameters: Codable {
			let q: String
		}
		return service.json(
			method: .get,
			path: [.search, .users],
			parameters: FindUserParameters(q: name),
			interceptor: nil,
            progress: nil) { [weak self] response in
				guard self != nil else { return }
				let userList = response.decodableValue(of: UserList.self)
				let users = userList?.users ?? []
				callback(users)
		}
	}
	
	func loadRepos(user: String, callback: @escaping ([Repository]) -> Void) {
		let path = "/users/\(user)/repos"
		service.json(
			method: .get,
			path: path,
			interceptor: nil,
            progress: nil) { [weak self] response in
				guard self != nil else { return }
				var repositories = response.decodableValue(of: [Repository].self) ?? []
				repositories = repositories.filter { $0.description != nil }
				callback(repositories)
		}
	}
}
