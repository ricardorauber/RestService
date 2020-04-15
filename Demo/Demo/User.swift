struct User: Codable {
	
	let login: String
	let avatarUrl: String
	
	private enum CodingKeys: String, CodingKey {
		case login
		case avatarUrl = "avatar_url"
	}
}
