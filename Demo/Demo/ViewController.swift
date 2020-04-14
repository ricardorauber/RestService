import UIKit
import RestService

class ViewController: UIViewController {
	
	var github: GitHubService!
	var repositories: [Repository] = []
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let service = RestService(host: "api.github.com")
		github = GitHubService(service: service)
		github.loadRepos(user: "ricardorauber") { [weak self] repositories in
			self?.repositories = repositories
			DispatchQueue.main.async {
				self?.tableView.reloadData()
			}
		}
	}
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return repositories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let repository = repositories[indexPath.row]
		cell.textLabel?.text = repository.name
		cell.detailTextLabel?.text = repository.description ?? "No description"
		return cell
	}
}
