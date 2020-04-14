import Quick
import Nimble
import OHHTTPStubs
@testable import RestService

class RestServiceTests: QuickSpec {
	override func spec() {
		
		var service: RestService!
		let timeout: TimeInterval = 3
		
		describe("RestService") {
			
			beforeEach {
				service = RestService(host: "server.com")
			}
			
			context("initialization") {
				
				it("should have set the right default values") {
					expect(service.scheme) == .https
					expect(service.host) == "server.com"
					expect(service.port).to(beNil())
				}
				
				it("should set the given values") {
					service = RestService(scheme: .http, host: "server.com", port: 3000)
					expect(service.scheme) == .http
					expect(service.host) == "server.com"
					expect(service.port) == 3000
				}
			}
			
			context("buildQueryItems") {
				
				it("should create a string query item") {
					let parameters = Parameters(
						string: "something",
						int: nil,
						stringsList: nil,
						intList: nil
					)
					let queryItems = service.buildQueryItems(parameters: parameters)
					expect(queryItems.count) == 1
					expect(queryItems.first?.name) == "string"
					expect(queryItems.first?.value) == "something"
				}
				
				it("should create an int query item") {
					let parameters = Parameters(
						string: nil,
						int: 10,
						stringsList: nil,
						intList: nil
					)
					let queryItems = service.buildQueryItems(parameters: parameters)
					expect(queryItems.count) == 1
					expect(queryItems.first?.name) == "int"
					expect(queryItems.first?.value) == "10"
				}
				
				it("should create a string array query item") {
					let parameters = Parameters(
						string: nil,
						int: nil,
						stringsList: ["abc", "def"],
						intList: nil
					)
					let queryItems = service.buildQueryItems(parameters: parameters)
					expect(queryItems.count) == 2
					expect(queryItems.first?.name) == "stringsList"
					expect(queryItems.first?.value) == "abc"
					expect(queryItems.last?.name) == "stringsList"
					expect(queryItems.last?.value) == "def"
				}
				
				it("should create an int array query item") {
					let parameters = Parameters(
						string: nil,
						int: nil,
						stringsList: nil,
						intList: [15, 20]
					)
					let queryItems = service.buildQueryItems(parameters: parameters)
					expect(queryItems.count) == 2
					expect(queryItems.first?.name) == "intList"
					expect(queryItems.first?.value) == "15"
					expect(queryItems.last?.name) == "intList"
					expect(queryItems.last?.value) == "20"
				}
				
				it("should create a full list query items") {
					let parameters = Parameters(
						string: "something",
						int: 10,
						stringsList: ["abc", "def"],
						intList: [15, 20]
					)
					let queryItems = service.buildQueryItems(parameters: parameters)
					expect(queryItems.count) == 6
					let string = queryItems.filter { $0.name == "string" }.first?.value
					expect(string) == "something"
					let int = queryItems.filter { $0.name == "int" }.first?.value
					expect(int) == "10"
					let stringsList1 = queryItems.filter { $0.name == "stringsList" }.first?.value
					expect(stringsList1) == "abc"
					let stringsList2 = queryItems.filter { $0.name == "stringsList" }.last?.value
					expect(stringsList2) == "def"
					let intList1 = queryItems.filter { $0.name == "intList" }.first?.value
					expect(intList1) == "15"
					let intList2 = queryItems.filter { $0.name == "intList" }.last?.value
					expect(intList2) == "20"
				}
			}
			
			context("jsonHeaders") {
				
				it("should have the right headers") {
					let headers = service.jsonHeaders()
					expect(headers["Content-Type"]) == "application/json"
				}
			}
			
			context("formDataHeaders") {
				
				it("should have the right headers") {
					let headers = service.formDataHeaders(boundary: "abcde")
					expect(headers["Content-Type"]) == "multipart/form-data; boundary=abcde"
				}
			}
			
			context("buildJsonBody") {
				
				it("should create a body with a string item") {
					let parameters = Parameters(
						string: "something",
						int: nil,
						stringsList: nil,
						intList: nil
					)
					let body = service.buildJsonBody(parameters: parameters)
					expect(body).toNot(beNil())
					let json = try? JSONSerialization.jsonObject(with: body!, options: .mutableContainers) as? [String: Any]
					expect(json).toNot(beNil())
					let string = json?["string"] as? String
					expect(string) == "something"
				}
				
				it("should create a body with an int item") {
					let parameters = Parameters(
						string: nil,
						int: 10,
						stringsList: nil,
						intList: nil
					)
					let body = service.buildJsonBody(parameters: parameters)
					expect(body).toNot(beNil())
					let json = try? JSONSerialization.jsonObject(with: body!, options: .mutableContainers) as? [String: Any]
					expect(json).toNot(beNil())
					let int = json?["int"] as? Int
					expect(int) == 10
				}
				
				it("should create a body with a string array item") {
					let parameters = Parameters(
						string: nil,
						int: nil,
						stringsList: ["abc", "def"],
						intList: nil
					)
					let body = service.buildJsonBody(parameters: parameters)
					expect(body).toNot(beNil())
					let json = try? JSONSerialization.jsonObject(with: body!, options: .mutableContainers) as? [String: Any]
					expect(json).toNot(beNil())
					let stringsList = json?["stringsList"] as? [String]
					expect(stringsList?.count) == 2
					expect(stringsList?.first) == "abc"
					expect(stringsList?.last) == "def"
				}
				
				it("should create a body with an int array item") {
					let parameters = Parameters(
						string: nil,
						int: nil,
						stringsList: nil,
						intList: [15, 20]
					)
					let body = service.buildJsonBody(parameters: parameters)
					expect(body).toNot(beNil())
					let json = try? JSONSerialization.jsonObject(with: body!, options: .mutableContainers) as? [String: Any]
					expect(json).toNot(beNil())
					let intList = json?["intList"] as? [Int]
					expect(intList?.count) == 2
					expect(intList?.first) == 15
					expect(intList?.last) == 20
				}
				
				it("should create a body with a full dictionary") {
					let parameters = Parameters(
						string: "something",
						int: 10,
						stringsList: ["abc", "def"],
						intList: [15, 20]
					)
					let body = service.buildJsonBody(parameters: parameters)
					expect(body).toNot(beNil())
					let json = try? JSONSerialization.jsonObject(with: body!, options: .mutableContainers) as? [String: Any]
					expect(json).toNot(beNil())
					let string = json?["string"] as? String
					expect(string) == "something"
					let int = json?["int"] as? Int
					expect(int) == 10
					let stringsList = json?["stringsList"] as? [String]
					expect(stringsList?.count) == 2
					expect(stringsList?.first) == "abc"
					expect(stringsList?.last) == "def"
					let intList = json?["intList"] as? [Int]
					expect(intList?.count) == 2
					expect(intList?.first) == 15
					expect(intList?.last) == 20
				}
			}
			
			context("buildFormDataBody") {
				
				it("should not build a body with an empty boundary") {
					let parameters: [FormDataParameter] = [
						TextFormDataParameter(name: "name", value: "value")
					]
					let data = service.buildFormDataBody(boundary: "", parameters: parameters)
					expect(data).to(beNil())
				}
				
				it("should not build a body with an empty parameters list") {
					let data = service.buildFormDataBody(boundary: "abcde", parameters: [])
					expect(data).to(beNil())
				}
				
				it("should create a body with a text parameter") {
					let parameters: [FormDataParameter] = [
						TextFormDataParameter(name: "user", value: "john")
					]
					let data = service.buildFormDataBody(boundary: "abcde", parameters: parameters)
					expect(data).toNot(beNil())
					let string = String(data: data!, encoding: .utf8)
					expect(string).toNot(beNil())
					expect(string) == "--abcde\r\nContent-Disposition: form-data; name=\"user\"\r\n\r\njohn\r\n--abcde--\r\n"
				}
				
				it("should create a body with a file parameter") {
					let parameters: [FormDataParameter] = [
						FileFormDataParameter(name: "photo", filename: "photo.jpg", contentType: "image/jpg", data: "image".data(using: .utf8)!)
					]
					let data = service.buildFormDataBody(boundary: "abcde", parameters: parameters)
					expect(data).toNot(beNil())
					let string = String(data: data!, encoding: .utf8)
					expect(string).toNot(beNil())
					expect(string) == "--abcde\r\nContent-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\nContent-Type: \"image/jpg\"\r\n\r\nimage\r\n--abcde--\r\n"
				}
				
				it("should create a body with multiple parameters") {
					let parameters: [FormDataParameter] = [
						TextFormDataParameter(name: "user", value: "john"),
						FileFormDataParameter(name: "photo", filename: "photo.jpg", contentType: "image/jpg", data: "image".data(using: .utf8)!)
					]
					let data = service.buildFormDataBody(boundary: "abcde", parameters: parameters)
					expect(data).toNot(beNil())
					let string = String(data: data!, encoding: .utf8)
					expect(string).toNot(beNil())
					expect(string) == "--abcde\r\nContent-Disposition: form-data; name=\"user\"\r\n\r\njohn\r\n--abcde\r\nContent-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\nContent-Type: \"image/jpg\"\r\n\r\nimage\r\n--abcde--\r\n"
				}
			}
			
			context("buildRequest") {
				
				it("should not create a request with an invalid path") {
					let request = service.buildRequest(
						method: .get,
						path: "a",
						queryItems: nil,
						headers: nil,
						body: nil,
						interceptor: nil)
					expect(request).to(beNil())
				}
				
				it("should create a basic request") {
					let request = service.buildRequest(
						method: .get,
						path: "/api",
						queryItems: nil,
						headers: nil,
						body: nil,
						interceptor: nil
					)
					expect(request).toNot(beNil())
					expect(request?.httpMethod) == "GET"
					expect(request?.url?.host) == "server.com"
					expect(request?.url?.path) == "/api"
				}
				
				it("should create a request with query items") {
					let request = service.buildRequest(
						method: .get,
						path: "/api",
						queryItems: [
							URLQueryItem(name: "user", value: "john")
						],
						headers: nil,
						body: nil,
						interceptor: nil
					)
					expect(request).toNot(beNil())
					expect(request?.url?.query) == "user=john"
				}
				
				it("should create a request with headers") {
					let request = service.buildRequest(
						method: .get,
						path: "/api",
						queryItems: nil,
						headers: [
							"Content-Type": "application/json"
						],
						body: nil,
						interceptor: nil
					)
					expect(request).toNot(beNil())
					expect(request?.allHTTPHeaderFields).toNot(beNil())
					expect(request?.allHTTPHeaderFields?.count) == 1
					expect(request?.allHTTPHeaderFields?["Content-Type"]) == "application/json"
				}
				
				it("should create a request with a body") {
					let body = "some data".data(using: .utf8)
					let request = service.buildRequest(
						method: .get,
						path: "/api",
						queryItems: nil,
						headers: nil,
						body: body,
						interceptor: nil
					)
					expect(request).toNot(beNil())
					expect(request?.httpBody).toNot(beNil())
					expect(request?.httpBody) == body
				}
				
				it("should create a request that was intercepted") {
					let request = service.buildRequest(
						method: .get,
						path: "/api",
						queryItems: nil,
						headers: nil,
						body: nil,
						interceptor: Interceptor()
					)
					expect(request).toNot(beNil())
					expect(request?.allHTTPHeaderFields).toNot(beNil())
					expect(request?.allHTTPHeaderFields?.count) == 1
					expect(request?.allHTTPHeaderFields?["dummy"]) == "dummy"
				}
				
				it("should create a full request") {
					let body = "some data".data(using: .utf8)
					let request = service.buildRequest(
						method: .get,
						path: "/api",
						queryItems: [
							URLQueryItem(name: "user", value: "john")
						],
						headers: [
							"Content-Type": "application/json"
						],
						body: body,
						interceptor: Interceptor()
					)
					expect(request).toNot(beNil())
					expect(request?.httpMethod) == "GET"
					expect(request?.url?.host) == "server.com"
					expect(request?.url?.path) == "/api"
					expect(request?.url?.query) == "user=john"
					expect(request?.allHTTPHeaderFields).toNot(beNil())
					expect(request?.allHTTPHeaderFields?.count) == 2
					expect(request?.allHTTPHeaderFields?["Content-Type"]) == "application/json"
					expect(request?.allHTTPHeaderFields?["dummy"]) == "dummy"
					expect(request?.httpBody).toNot(beNil())
					expect(request?.httpBody) == body
				}
			}
			
			context("buildTask") {
				
				it("should not build a task with no request") {
					let result = service.buildTask(request: nil) { _ in }
					expect(result).to(beNil())
				}
				
				it("should build a task from a given request") {
					let request = service.buildRequest(
						method: .get,
						path: "/api",
						queryItems: nil,
						headers: nil,
						body: nil,
						interceptor: nil
					)
					let result = service.buildTask(request: request) { _ in }
					expect(result).toNot(beNil())
				}
			}
			
			context("HTTPService") {

				beforeEach {
					HTTPStubs.removeAllStubs()
					stub(condition: isHost("server.com")) { _ in
						return HTTPStubsResponse(jsonObject: ["string": "completed"], statusCode: 200, headers: nil)
					}
				}

				context("json") {

					it("should create a json request without parameters") {
						var completed = false
						let task = service.json(
							method: .get,
							path: "/api",
							interceptor: Interceptor()) { response in
								expect(response.data).toNot(beNil())
								expect(response.request).toNot(beNil())
								expect(response.response).toNot(beNil())
								expect(response.error).to(beNil())
								expect(response.request?.httpMethod) == "GET"
								expect(response.request?.url?.host) == "server.com"
								expect(response.request?.url?.path) == "/api"
								expect(response.request?.url?.query).to(beNil())
								expect(response.request?.allHTTPHeaderFields).toNot(beNil())
								expect(response.request?.allHTTPHeaderFields?.count) == 2
								expect(response.request?.allHTTPHeaderFields?["Content-Type"]) == "application/json"
								expect(response.request?.allHTTPHeaderFields?["dummy"]) == "dummy"
								expect(response.request?.httpBody).to(beNil())
								expect(response.stringValue()).toNot(beNil())
								expect(response.stringValue()) == "{\"string\":\"completed\"}"
								let decodable = response.decodableValue(of: Parameters.self)
								expect(decodable).toNot(beNil())
								expect(decodable?.string) == "completed"
								let dictionary = response.dictionaryValue()
								expect(dictionary).toNot(beNil())
								expect(dictionary?["string"] as? String) == "completed"
								completed = true
						}
						expect(task).toNot(beNil())
						expect(completed).toEventually(beTrue(), timeout: timeout)
					}

					it("should create a json request with query items") {
						var completed = false
						let task = service.json(
							method: .get,
							path: "/api",
							parameters: Parameters(string: "completed", int: nil, stringsList: nil, intList: nil),
							interceptor: Interceptor()) { response in
								expect(response.data).toNot(beNil())
								expect(response.request).toNot(beNil())
								expect(response.response).toNot(beNil())
								expect(response.error).to(beNil())
								expect(response.request?.httpMethod) == "GET"
								expect(response.request?.url?.host) == "server.com"
								expect(response.request?.url?.path) == "/api"
								expect(response.request?.url?.query) == "string=completed"
								expect(response.request?.allHTTPHeaderFields).toNot(beNil())
								expect(response.request?.allHTTPHeaderFields?.count) == 2
								expect(response.request?.allHTTPHeaderFields?["Content-Type"]) == "application/json"
								expect(response.request?.allHTTPHeaderFields?["dummy"]) == "dummy"
								expect(response.request?.httpBody).to(beNil())
								expect(response.stringValue()).toNot(beNil())
								expect(response.stringValue()) == "{\"string\":\"completed\"}"
								let decodable = response.decodableValue(of: Parameters.self)
								expect(decodable).toNot(beNil())
								expect(decodable?.string) == "completed"
								let dictionary = response.dictionaryValue()
								expect(dictionary).toNot(beNil())
								expect(dictionary?["string"] as? String) == "completed"
								completed = true
						}
						expect(task).toNot(beNil())
						expect(completed).toEventually(beTrue(), timeout: timeout)
					}

					it("should create a json request with body") {
						var completed = false
						let task = service.json(
							method: .post,
							path: "/api",
							parameters: Parameters(string: "completed", int: nil, stringsList: nil, intList: nil),
							interceptor: Interceptor()) { response in
								expect(response.data).toNot(beNil())
								expect(response.request).toNot(beNil())
								expect(response.response).toNot(beNil())
								expect(response.error).to(beNil())
								expect(response.request?.httpMethod) == "POST"
								expect(response.request?.url?.host) == "server.com"
								expect(response.request?.url?.path) == "/api"
								expect(response.request?.url?.query).to(beNil())
								expect(response.request?.allHTTPHeaderFields).toNot(beNil())
								expect(response.request?.allHTTPHeaderFields?.count) == 2
								expect(response.request?.allHTTPHeaderFields?["Content-Type"]) == "application/json"
								expect(response.request?.allHTTPHeaderFields?["dummy"]) == "dummy"
								expect(response.request?.httpBody).toNot(beNil())
								let body = try? JSONDecoder().decode(Parameters.self, from: response.request!.httpBody!)
								expect(body).toNot(beNil())
								expect(body?.string) == "completed"
								expect(response.stringValue()).toNot(beNil())
								expect(response.stringValue()) == "{\"string\":\"completed\"}"
								let decodable = response.decodableValue(of: Parameters.self)
								expect(decodable).toNot(beNil())
								expect(decodable?.string) == "completed"
								let dictionary = response.dictionaryValue()
								expect(dictionary).toNot(beNil())
								expect(dictionary?["string"] as? String) == "completed"
								completed = true
						}
						expect(task).toNot(beNil())
						expect(completed).toEventually(beTrue(), timeout: timeout)
					}
				}
				
				context("formData") {
					
					it("should create a form data request") {
						var completed = false
						let task = service.formData(
							method: .post,
							path: "/api",
							parameters: [
								TextFormDataParameter(name: "string", value: "completed")
							],
							interceptor: Interceptor()) { response in
								expect(response.data).toNot(beNil())
								expect(response.request).toNot(beNil())
								expect(response.response).toNot(beNil())
								expect(response.error).to(beNil())
								expect(response.request?.httpMethod) == "POST"
								expect(response.request?.url?.host) == "server.com"
								expect(response.request?.url?.path) == "/api"
								expect(response.request?.url?.query).to(beNil())
								expect(response.request?.allHTTPHeaderFields).toNot(beNil())
								expect(response.request?.allHTTPHeaderFields?.count) == 2
								let headerPrefix = "multipart/form-data; boundary="
								let boundary = response.request?.allHTTPHeaderFields?["Content-Type"]?.dropFirst(headerPrefix.count)
								expect(boundary).toNot(beNil())
								expect(response.request?.allHTTPHeaderFields?["Content-Type"]) == headerPrefix + boundary!
								expect(response.request?.allHTTPHeaderFields?["dummy"]) == "dummy"
								expect(response.request?.httpBody).toNot(beNil())
								let body = String(data: response.request!.httpBody!, encoding: .utf8)
								expect(body).toNot(beNil())
								expect(body) == "--\(boundary!)\r\nContent-Disposition: form-data; name=\"string\"\r\n\r\ncompleted\r\n--\(boundary!)--\r\n"
								expect(response.stringValue()).toNot(beNil())
								expect(response.stringValue()) == "{\"string\":\"completed\"}"
								let decodable = response.decodableValue(of: Parameters.self)
								expect(decodable).toNot(beNil())
								expect(decodable?.string) == "completed"
								let dictionary = response.dictionaryValue()
								expect(dictionary).toNot(beNil())
								expect(dictionary?["string"] as? String) == "completed"
								completed = true
						}
						expect(task).toNot(beNil())
						expect(completed).toEventually(beTrue(), timeout: timeout)
					}
				}
			}
		}
	}
}

// MARK: - Private helpers

private struct Parameters: Codable {
	let string: String?
	let int: Int?
	let stringsList: [String]?
	let intList: [Int]?
}

private struct Interceptor: RestRequestInterceptor {
	func adapt(request: URLRequest) -> URLRequest {
		var request = request
		request.addValue("dummy", forHTTPHeaderField: "dummy")
		return request
	}
}
