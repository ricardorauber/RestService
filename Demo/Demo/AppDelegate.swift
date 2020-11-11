import UIKit
import RestService

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let scene = storyboard.instantiateInitialViewController() as? SearchUserViewController
		let service = RestService(debug: true, host: "api.github.com")
		let github = GitHubService(service: service)
		scene?.github = github
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = scene
		window?.makeKeyAndVisible()
		
		return true
	}
}
