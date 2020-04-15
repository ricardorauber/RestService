// Path component to build a rest path
public struct RestPath: RawRepresentable, Equatable, Hashable {
	
	public typealias RawValue = String
	public let rawValue: String
	
	// MARK: - Initialization
	
	public init(rawValue: String) {
		self.rawValue = rawValue
	}
}
