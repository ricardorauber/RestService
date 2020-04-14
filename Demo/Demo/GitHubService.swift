import RestService

struct Owner: Codable {
	let login: String
	let avatarUrl: String
	
	private enum CodingKeys: String, CodingKey {
	  case login
	  case avatarUrl = "avatar_url"
	}
}

struct Repository: Codable {
	let name: String
	let description: String?
	let owner: Owner
}

class GitHubService {
	
	let service: RestService
	
	init(service: RestService) {
		self.service = service
	}
	
	func loadRepos(user: String, callback: @escaping ([Repository]) -> Void) {
		let path = "/users/\(user)/repos"
		service.json(
			method: .get,
			path: path,
			interceptor: nil) { [weak self] response in
				guard self != nil else { return }
				var repositories = response.decodableValue(of: [Repository].self) ?? []
				repositories = repositories.filter { $0.description != nil }
				callback(repositories)
		}
	}
}
