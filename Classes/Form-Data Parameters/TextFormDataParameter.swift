import Foundation

public struct TextFormDataParameter {

    // MARK: - Properties

    public let name: String
	public let value: String
    
    // MARK: - Initialization
	
	public init(name: String, value: String) {
		self.name = name
		self.value = value
	}
}

// MARK: - FormDataParameter
extension TextFormDataParameter: FormDataParameter {

	public func formData(boundary: String) -> Data? {
		guard !name.isEmpty,
			!value.isEmpty,
			!boundary.isEmpty
			else {
				return nil
		}
		var formContent = "--" + boundary + "\r\n"
		formContent += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
		formContent += "\r\n"
		formContent += value + "\r\n"
		return formContent.data(using: .utf8)
	}
}
