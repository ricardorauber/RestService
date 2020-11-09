import Foundation

struct UserList: Codable {
	
	let total: Int
	let users: [User]
	
	private enum CodingKeys: String, CodingKey {
		case total = "total_count"
		case users = "items"
	}
}
