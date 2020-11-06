import Foundation

struct PathBuilder {
    
    func build(_ path: [RestPath]) -> String {
        let stringPaths = path.map { $0.rawValue }
        let fullPath = "/" + stringPaths.joined(separator: "/")
        return fullPath
    }
}
