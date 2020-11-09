import UIKit
import RestService

class SearchUserViewController: UIViewController {
	
	// MARK: - Properties
	
	var github: GitHubService!
	var users: [User] = []
	var task: RestTask?
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var searchTextField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: - IBActions
	
	@IBAction func okButtonTouchUpInside(_ sender: Any) {
		view.endEditing(true)
	}
	
	// MARK: - Life cycle
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showRepos",
			let destination = segue.destination as? UserReposViewController,
			let user = sender as? User {
			
			destination.github = github
			destination.user = user
		}
	}
	
	// MARK: - Service
	
	func loadUsers(name: String) {
		task?.cancel()
		users = []
		tableView.reloadData()
		task = github.findUsers(name: name) { [weak self] users in
			self?.users = users
			DispatchQueue.main.async {
				self?.tableView.reloadData()
			}
		}
	}
}

// MARK: - UITableViewDataSource
extension SearchUserViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let user = users[indexPath.row]
		cell.textLabel?.text = user.login
		return cell
	}
}

// MARK: - UITableViewDelegate
extension SearchUserViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let user = users[indexPath.row]
		performSegue(withIdentifier: "showRepos", sender: user)
	}
}

// MARK: - UITextFieldDelegate
extension SearchUserViewController: UITextFieldDelegate {

	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		if let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string), text.count >= 3 {
			loadUsers(name: text)
		}
		return true
	}
}
