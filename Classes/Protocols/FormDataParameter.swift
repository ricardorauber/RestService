/// Protocol to generate form data
public protocol FormDataParameter {
	
	/// Generates data for the form data request
	///
	/// - Parameter boundary: Identifier of the parts of the request
	func formData(boundary: String) -> Data?
}
