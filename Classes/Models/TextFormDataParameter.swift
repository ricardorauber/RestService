public struct TextFormDataParameter: FormDataParameter {

	let name: String
	let value: String
	
	public init(name: String, value: String) {
		self.name = name
		self.value = value
	}

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
