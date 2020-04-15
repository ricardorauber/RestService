import Quick
import Nimble
@testable import RestService

class RestResponseTests: QuickSpec {
	override func spec() {
		
		var restResponse: RestResponse!
		var data: Data!
		var url: URL!
		var request: URLRequest!
		var statusCode: Int!
		var headers: [String : String]!
		var response: HTTPURLResponse!
		var error: DummyError!
		
		describe("RestResponse") {
			
			beforeEach {
				data = "some".data(using: .utf8)
				url = URL(string: "http://server.com")!
				request = URLRequest(url: url)
				statusCode = 200
				headers = ["dummy": "dummy"]
				response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: headers)
				error = DummyError(message: "error")
				restResponse = RestResponse(data: data, request: request, response: response, error: error)
			}
			
			context("initialization") {
				
				it("should have the right parameters") {
					expect(restResponse).toNot(beNil())
					expect(restResponse.data) == data
					expect(restResponse.request) == request
					expect(restResponse.response) == response
				}
			}
			
			context("computed properties") {
				
				it("should have the right status code") {
					expect(restResponse.statusCode) == 200
				}
				
				it("should have statusCode -1 when there is no http response") {
					restResponse = RestResponse(data: nil, request: nil, response: nil, error: nil)
					expect(restResponse.statusCode) == -1
				}
				
				it("should have the right headers") {
					expect(restResponse.headers).toNot(beNil())
					expect(restResponse.headers?.count) == 1
				}
				
				it("should not have headers without http response") {
					restResponse = RestResponse(data: nil, request: nil, response: nil, error: nil)
					expect(restResponse.headers).to(beNil())
				}
			}
			
			context("data conversion") {
				
				it("should have a nil string if there is no data") {
					restResponse = RestResponse(data: nil, request: nil, response: nil, error: nil)
					expect(restResponse.stringValue()).to(beNil())
				}
				
				it("should convert a string value with the default encoding") {
					let data = "some data".data(using: .utf8)
					restResponse = RestResponse(data: data, request: nil, response: nil, error: nil)
					expect(restResponse.stringValue()).toNot(beNil())
					expect(restResponse.stringValue()) == "some data"
				}
				
				it("should convert a string value with a given encoding") {
					let data = "some data".data(using: .isoLatin1)
					restResponse = RestResponse(data: data, request: nil, response: nil, error: nil)
					expect(restResponse.stringValue(encoding: .isoLatin1)).toNot(beNil())
					expect(restResponse.stringValue(encoding: .isoLatin1)) == "some data"
				}
				
				it("should have a nil int if there is no data") {
					restResponse = RestResponse(data: nil, request: nil, response: nil, error: nil)
					expect(restResponse.intValue()).to(beNil())
				}
				
				it("should convert an int value") {
					let data = "15".data(using: .utf8)
					restResponse = RestResponse(data: data, request: nil, response: nil, error: nil)
					expect(restResponse.intValue()).toNot(beNil())
					expect(restResponse.intValue()) == 15
				}
				
				it("should have a nil double if there is no data") {
					restResponse = RestResponse(data: nil, request: nil, response: nil, error: nil)
					expect(restResponse.doubleValue()).to(beNil())
				}
				
				it("should convert a double value") {
					let data = "15.2".data(using: .utf8)
					restResponse = RestResponse(data: data, request: nil, response: nil, error: nil)
					expect(restResponse.doubleValue()).toNot(beNil())
					expect(restResponse.doubleValue()) == 15.2
				}
				
				it("should have a nil decodable value if there is no data") {
					restResponse = RestResponse(data: nil, request: nil, response: nil, error: nil)
					expect(restResponse.decodableValue(of: User.self)).to(beNil())
				}
				
				it("should convert a decodable value") {
					let user = User(name: "john")
					let data = try? JSONEncoder().encode(user)
					restResponse = RestResponse(data: data, request: nil, response: nil, error: nil)
					let result = restResponse.decodableValue(of: User.self)
					expect(result).toNot(beNil())
					expect(result?.name) == "john"
				}
				
				it("should convert a decodable list") {
					let users: [User] = [
						User(name: "john"),
						User(name: "paul")
					]
					let data = try? JSONEncoder().encode(users)
					restResponse = RestResponse(data: data, request: nil, response: nil, error: nil)
					let result = restResponse.decodableValue(of: [User].self)
					expect(result).toNot(beNil())
					expect(result?.first?.name) == "john"
					expect(result?.last?.name) == "paul"
				}
				
				it("should have a nil dictionary value if there is no data") {
					restResponse = RestResponse(data: nil, request: nil, response: nil, error: nil)
					expect(restResponse.dictionaryValue()).to(beNil())
				}
				
				it("should convert a dictionary value") {
					let user: [String: Any] = [
						"name": "john"
					]
					let data = try? JSONSerialization.data(withJSONObject: user, options: .prettyPrinted)
					restResponse = RestResponse(data: data, request: nil, response: nil, error: nil)
					let result = restResponse.dictionaryValue()
					expect(result).toNot(beNil())
					expect(result?["name"] as? String) == "john"
				}
				
				it("should have a nil array value if there is no data") {
					restResponse = RestResponse(data: nil, request: nil, response: nil, error: nil)
					expect(restResponse.arrayValue()).to(beNil())
				}
				
				it("should convert a array value") {
					let users: [String] = ["john", "paul"]
					let data = try? JSONSerialization.data(withJSONObject: users, options: .prettyPrinted)
					restResponse = RestResponse(data: data, request: nil, response: nil, error: nil)
					let result = restResponse.arrayValue()
					expect(result).toNot(beNil())
					expect(result?.first as? String) == "john"
					expect(result?.last as? String) == "paul"
				}
			}
		}
	}
}

// MARK: - Private helpers

private struct DummyError: Error, Equatable {
	let message: String
}

private struct User: Codable {
	let name: String
}
