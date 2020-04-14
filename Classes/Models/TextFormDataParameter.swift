/// Text type of parameter for a Form Data request
public struct TextFormDataParameter {

	/// Name of the parameter
	public let name: String
	
	/// Value of the parameter
	public let value: String
	
	/// Creates a new instance of the TextFormDataParameter
	///
	/// - Parameters:
	///   - name: Name of the parameter
	///   - value: Value of the parameter
	public init(name: String, value: String) {
		self.name = name
		self.value = value
	}
}

// MARK: - FormDataParameter
extension TextFormDataParameter: FormDataParameter {

	func formData(boundary: String) -> Data? {
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
