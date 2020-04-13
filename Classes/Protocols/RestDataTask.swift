/// Data task of the HTTP service
public protocol RestDataTask {
	
	/// Temporarily suspends a task
	func suspend()
	
	/// Resumes the task, if it is suspended
	func resume()
	
	/// Cancels the task
	func cancel()
}

// MARK: - Apply Extensions
extension URLSessionDataTask: RestDataTask {}
