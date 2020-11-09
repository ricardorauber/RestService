import Foundation

struct Repository: Codable {
	
	let name: String
	let description: String?
	let owner: User
}
