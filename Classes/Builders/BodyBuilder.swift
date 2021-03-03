import Foundation

struct BodyBuilder {

    var encoder: JSONEncoder = JSONEncoder()
    
    func isAllowed(method: HTTPMethod) -> Bool {
        method != .get && method != .head && method != .delete
    }
    
    func buildJson<T: Codable>(method: HTTPMethod, parameters: T) -> Data? {
        guard isAllowed(method: method) else { return nil }
        return try? encoder.encode(parameters)
    }
    
    func buildJson(method: HTTPMethod, parameters: [String: Any]) -> Data? {
        guard isAllowed(method: method) else { return nil }
        return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
    
    func buildFormData(method: HTTPMethod, boundary: String, parameters: [FormDataParameter]) -> Data? {
        guard isAllowed(method: method),
              !boundary.isEmpty,
              parameters.count > 0
        else {
            return nil
        }
        var data = Data()
        for parameter in parameters {
            if let formData = parameter.formData(boundary: boundary) {
                data.append(formData)
            }
        }
        if let formData = "--\(boundary)--\r\n".data(using: .utf8) {
            data.append(formData)
        }
        return data
    }
    
    func buildFormUrlEncoded<T: Codable>(method: HTTPMethod, parameters: T) -> Data? {
        guard isAllowed(method: method),
            let data = try? encoder.encode(parameters),
            let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        else { return nil }
        return buildFormUrlEncoded(method: method, parameters: dictionary)
    }
    
    func buildFormUrlEncoded(method: HTTPMethod, parameters: [String: Any]) -> Data? {
        guard isAllowed(method: method) else { return nil }
        var body = ""
        for (key, value) in parameters {
            body = body + key + "=\(value)&"
        }
        body.removeLast()
        return body.data(using: .utf8)
    }
}
