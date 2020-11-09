import Foundation

struct QueryItemsBuilder {
    
    func isAllowed(method: HTTPMethod) -> Bool {
        method == .get || method == .head || method == .delete
    }
    
    func build<T: Codable>(method: HTTPMethod, parameters: T) -> [URLQueryItem]? {
        guard let encoded = try? JSONEncoder().encode(parameters),
              let decoded = try? JSONSerialization.jsonObject(with: encoded, options: .mutableContainers) as? [String: Any]
        else {
            return nil
        }
        return build(method: method, parameters: decoded)
    }
    
    func build(method: HTTPMethod, parameters: [String: Any]) -> [URLQueryItem]? {
        guard isAllowed(method: method) else { return nil }
        var queryItems: [URLQueryItem] = []
        for (key, value) in parameters {
            if let items = value as? [Any] {
                for item in items {
                    queryItems.append(URLQueryItem(name: key, value: String(describing: item)))
                }
            } else {
                queryItems.append(URLQueryItem(name: key, value: String(describing: value)))
            }
        }
        return queryItems
    }
}
