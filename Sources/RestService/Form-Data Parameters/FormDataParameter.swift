import Foundation

public protocol FormDataParameter {
    
	func formData(boundary: String) -> Data?
}
