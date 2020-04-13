import UIKit
import RestService

class ViewController: UIViewController {
	
	// MARK: - IBOutlets
	
	@IBOutlet weak var storageTypeSegmentedControl: UISegmentedControl!
	@IBOutlet weak var keyTextField: UITextField!
	@IBOutlet weak var valueTextField: UITextField!
	@IBOutlet weak var valueSwitch: UISwitch!
	@IBOutlet weak var valueTypeSegmentedControl: UISegmentedControl!
	
	// MARK: - IBActions
	
	@IBAction func setValueButtonTouchUpInside(_ sender: Any) {}
	
	@IBAction func loadValueButtonTouchUpInside(_ sender: Any) {}
	
	@IBAction func removeKeyButtonTouchUpInside(_ sender: Any) {}
	
	@IBAction func clearStorageButtonTouchUpInside(_ sender: Any) {}
	
	@IBAction func valueTypeSegmentedControlValueChanged(_ sender: Any) {}
	
	// MARK: - Tests
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}

