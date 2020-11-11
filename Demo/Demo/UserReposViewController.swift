import UIKit
import RestService

class UserReposViewController: UIViewController {
    
    // MARK: - Properties
    
    var github: GitHubService!
    var task: RestTask?
    var user: User!
    var repositories: [Repository] = []
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRepos()
    }
    
    // MARK: - Service
    
    func loadRepos() {
        task?.cancel()
        task = github.loadRepos(user: user.login) { [weak self] repositories in
            self?.repositories = repositories
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension UserReposViewController: UITableViewDataSource {
    
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

// MARK: - UITableViewDelegate
extension UserReposViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
