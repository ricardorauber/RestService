public struct FileFormDataParameter: FormDataParameter {

	let name: String
	let filename: String
	let contentType: String
	let data: Data
	
	public init(name: String,
				filename: String,
				contentType: String,
				data: Data) {
		
		self.name = name
		self.filename = filename
		self.contentType = contentType
		self.data = data
	}

	func formData(boundary: String) -> Data? {
		guard !name.isEmpty,
			!filename.isEmpty,
			!contentType.isEmpty,
			!boundary.isEmpty
			else {
				return nil
		}
		var formData = Data()
		var formContent = "--" + boundary + "\r\n"
		formContent += "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n"
		formContent += "Content-Type: \"\(contentType)\"\r\n"
		formContent += "\r\n"
		if let parameterData = formContent.data(using: .utf8) {
			formData.append(parameterData)
		}
		formData.append(data)
		formContent = "\r\n"
		if let parameterData = formContent.data(using: .utf8) {
			formData.append(parameterData)
		}
		return formData
	}
}
