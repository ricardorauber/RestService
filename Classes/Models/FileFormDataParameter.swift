/// File type of parameter for a Form Data request
public struct FileFormDataParameter {

	/// Name of the parameter
	public let name: String
	
	/// Name of the file
	public let filename: String
	
	/// Type of content
	public let contentType: String
	
	/// Data of the file
	public let data: Data
	
	// MARK: - Initialization
	
	/// Creates a new instance of the FileFormDataParameter
	///
	/// - Parameters:
	///   - name: Name of the parameter
	///   - filename: Name of the file
	///   - contentType: Type of content
	///   - data: Data of the file
	public init(name: String,
				filename: String,
				contentType: String,
				data: Data) {
		
		self.name = name
		self.filename = filename
		self.contentType = contentType
		self.data = data
	}
}

// MARK: - FormDataParameter
extension FileFormDataParameter: FormDataParameter {
	
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
