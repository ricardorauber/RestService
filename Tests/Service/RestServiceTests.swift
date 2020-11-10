import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import RestService

class RestServiceTests: QuickSpec {
	override func spec() {

		var service: RestService!
//		let timeout: TimeInterval = 3

		describe("RestService") {
			
			beforeEach {
				service = RestService(host: "server.com")
			}

			context("initialization") {

				it("should have set the right default values") {
					expect(service.scheme) == .https
					expect(service.host) == "server.com"
					expect(service.port).to(beNil())
                    expect(service.startTasksAutomatically).to(beTrue())
				}

				it("should set the given values") {
					service = RestService(
                        scheme: .http,
                        host: "server.com",
                        port: 3000,
                        startTasksAutomatically: false
                    )
					expect(service.scheme) == .http
					expect(service.host) == "server.com"
					expect(service.port) == 3000
                    expect(service.startTasksAutomatically).to(beFalse())
				}
			}
            
            context("isValid") {
                
                it("should be true for valid responses") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: nil)
                    expect(service.isValid(response: response)).to(beTrue())
                }
                
                it("should be false for an invalid status code") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: nil)
                    expect(service.isValid(response: response)).to(beFalse())
                }
                
                it("should be false when there is an error on the response") {
                    let url = URL(string: "https://server.com")!
                    let error = SimpleError(code: "")
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: error)
                    expect(service.isValid(response: response)).to(beFalse())
                }
            }
            
            context("prepare") {
                
                it("should be success for a valid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: nil)
                    expect(service.prepare(response: response)) == .success
                }
                
                it("should be failure for an invalid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: nil)
                    expect(service.prepare(response: response)) == .failure
                }
            }
            
            context("prepare<D: Decodable>") {
                
                it("should be success for a valid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object = Person(name: "Mark")
                    let data = try? JSONEncoder().encode(object)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Person.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == object
                    default:
                        fail()
                    }
                }
                
                it("should be failure for an invalid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Person.self)
                    switch result {
                    case .failure:
                        break
                    default:
                        fail()
                    }
                }
            }
            
            context("prepare<E: Decodable>") {
                
                it("should be success for a valid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, customError: SimpleError.self)
                    switch result {
                    case .success:
                        break
                    default:
                        fail()
                    }
                }
                
                it("should be a custom error for a matched response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object = SimpleError(code: "10")
                    let data = try? JSONEncoder().encode(object)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, customError: SimpleError.self)
                    switch result {
                    case .customError(let responseObject):
                        expect(responseObject.code) == object.code
                    default:
                        fail()
                    }
                }
                
                it("should be failure for an invalid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, customError: SimpleError.self)
                    switch result {
                    case .failure:
                        break
                    default:
                        fail()
                    }
                }
            }
            
            context("prepare<D: Decodable,E: Decodable>") {
                
                it("should be success for a valid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object = Person(name: "Mark")
                    let data = try? JSONEncoder().encode(object)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Person.self, customError: SimpleError.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == object
                    default:
                        fail()
                    }
                }
                
                it("should be a custom error for a matched response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object = SimpleError(code: "10")
                    let data = try? JSONEncoder().encode(object)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Person.self, customError: SimpleError.self)
                    switch result {
                    case .customError(let responseObject):
                        expect(responseObject.code) == object.code
                    default:
                        fail()
                    }
                }
                
                it("should be failure for an invalid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Person.self, customError: SimpleError.self)
                    switch result {
                    case .failure:
                        break
                    default:
                        fail()
                    }
                }
            }

//			context("RestServiceProtocol") {
//
//				beforeEach {
//					HTTPStubs.removeAllStubs()
//					stub(condition: isHost("server.com")) { _ in
//						return HTTPStubsResponse(jsonObject: ["string": "completed"], statusCode: 200, headers: nil)
//					}
//				}
//
//				context("json") {
//
//					it("should create a json request without parameters for a string path") {
//						var completed = false
//						let task = service.json(
//							method: .get,
//							path: "/api",
//							interceptor: Interceptor()) { response in
//								expect(response.data).toNot(beNil())
//								expect(response.request).toNot(beNil())
//								expect(response.response).toNot(beNil())
//								expect(response.error).to(beNil())
//								expect(response.request?.httpMethod) == "GET"
//								expect(response.request?.url?.host) == "server.com"
//								expect(response.request?.url?.path) == "/api"
//								expect(response.request?.url?.query).to(beNil())
//								expect(response.request?.allHTTPHeaderFields).toNot(beNil())
//								expect(response.request?.allHTTPHeaderFields?.count) == 2
//								expect(response.request?.allHTTPHeaderFields?["Content-Type"]) == "application/json; charset=utf-8"
//								expect(response.request?.allHTTPHeaderFields?["dummy"]) == "dummy"
//								expect(response.request?.httpBody).to(beNil())
//								expect(response.stringValue()).toNot(beNil())
//								expect(response.stringValue()) == "{\"string\":\"completed\"}"
//								let decodable = response.decodableValue(of: Parameters.self)
//								expect(decodable).toNot(beNil())
//								expect(decodable?.string) == "completed"
//								let dictionary = response.dictionaryValue()
//								expect(dictionary).toNot(beNil())
//								expect(dictionary?["string"] as? String) == "completed"
//								completed = true
//						}
//						expect(task).toNot(beNil())
//						expect(completed).toEventually(beTrue(), timeout: timeout)
//					}
//
//					context("codable object") {
//
//						it("should create a json request with query items for a string path") {
//							var completed = false
//							let task = service.json(
//								method: .get,
//								path: "/api",
//								parameters: Parameters(string: "completed", int: nil, stringsList: nil, intList: nil),
//								interceptor: Interceptor()) { response in
//									expect(response.data).toNot(beNil())
//									expect(response.request).toNot(beNil())
//									expect(response.response).toNot(beNil())
//									expect(response.error).to(beNil())
//									expect(response.request?.httpMethod) == "GET"
//									expect(response.request?.url?.host) == "server.com"
//									expect(response.request?.url?.path) == "/api"
//									expect(response.request?.url?.query) == "string=completed"
//									expect(response.request?.allHTTPHeaderFields).toNot(beNil())
//									expect(response.request?.allHTTPHeaderFields?.count) == 2
//									expect(response.request?.allHTTPHeaderFields?["Content-Type"]) == "application/json; charset=utf-8"
//									expect(response.request?.allHTTPHeaderFields?["dummy"]) == "dummy"
//									expect(response.request?.httpBody).to(beNil())
//									expect(response.stringValue()).toNot(beNil())
//									expect(response.stringValue()) == "{\"string\":\"completed\"}"
//									let decodable = response.decodableValue(of: Parameters.self)
//									expect(decodable).toNot(beNil())
//									expect(decodable?.string) == "completed"
//									let dictionary = response.dictionaryValue()
//									expect(dictionary).toNot(beNil())
//									expect(dictionary?["string"] as? String) == "completed"
//									completed = true
//							}
//							expect(task).toNot(beNil())
//							expect(completed).toEventually(beTrue(), timeout: timeout)
//						}
//
//						it("should create a json request with body for a string path") {
//							var completed = false
//							let task = service.json(
//								method: .post,
//								path: "/api",
//								parameters: Parameters(string: "completed", int: nil, stringsList: nil, intList: nil),
//								interceptor: Interceptor()) { response in
//									expect(response.data).toNot(beNil())
//									expect(response.request).toNot(beNil())
//									expect(response.response).toNot(beNil())
//									expect(response.error).to(beNil())
//									expect(response.request?.httpMethod) == "POST"
//									expect(response.request?.url?.host) == "server.com"
//									expect(response.request?.url?.path) == "/api"
//									expect(response.request?.url?.query).to(beNil())
//									expect(response.request?.allHTTPHeaderFields).toNot(beNil())
//									expect(response.request?.allHTTPHeaderFields?.count) == 2
//									expect(response.request?.allHTTPHeaderFields?["Content-Type"]) == "application/json; charset=utf-8"
//									expect(response.request?.allHTTPHeaderFields?["dummy"]) == "dummy"
//									expect(response.request?.httpBody).toNot(beNil())
//									let body = try? JSONDecoder().decode(Parameters.self, from: response.request!.httpBody!)
//									expect(body).toNot(beNil())
//									expect(body?.string) == "completed"
//									expect(response.stringValue()).toNot(beNil())
//									expect(response.stringValue()) == "{\"string\":\"completed\"}"
//									let decodable = response.decodableValue(of: Parameters.self)
//									expect(decodable).toNot(beNil())
//									expect(decodable?.string) == "completed"
//									let dictionary = response.dictionaryValue()
//									expect(dictionary).toNot(beNil())
//									expect(dictionary?["string"] as? String) == "completed"
//									completed = true
//							}
//							expect(task).toNot(beNil())
//							expect(completed).toEventually(beTrue(), timeout: timeout)
//						}
//					}
//
//					context("dictionary") {
//
//						it("should create a json request with query items for a string path") {
//							var completed = false
//							let parameters: [String: Any] = ["string": "completed"]
//							let task = service.json(
//								method: .get,
//								path: "/api",
//								parameters: parameters,
//								interceptor: Interceptor()) { response in
//									expect(response.data).toNot(beNil())
//									expect(response.request).toNot(beNil())
//									expect(response.response).toNot(beNil())
//									expect(response.error).to(beNil())
//									expect(response.request?.httpMethod) == "GET"
//									expect(response.request?.url?.host) == "server.com"
//									expect(response.request?.url?.path) == "/api"
//									expect(response.request?.url?.query) == "string=completed"
//									expect(response.request?.allHTTPHeaderFields).toNot(beNil())
//									expect(response.request?.allHTTPHeaderFields?.count) == 2
//									expect(response.request?.allHTTPHeaderFields?["Content-Type"]) == "application/json; charset=utf-8"
//									expect(response.request?.allHTTPHeaderFields?["dummy"]) == "dummy"
//									expect(response.request?.httpBody).to(beNil())
//									expect(response.stringValue()).toNot(beNil())
//									expect(response.stringValue()) == "{\"string\":\"completed\"}"
//									let decodable = response.decodableValue(of: Parameters.self)
//									expect(decodable).toNot(beNil())
//									expect(decodable?.string) == "completed"
//									let dictionary = response.dictionaryValue()
//									expect(dictionary).toNot(beNil())
//									expect(dictionary?["string"] as? String) == "completed"
//									completed = true
//							}
//							expect(task).toNot(beNil())
//							expect(completed).toEventually(beTrue(), timeout: timeout)
//						}
//
//						it("should create a json request with body for a string path") {
//							var completed = false
//							let parameters: [String: Any] = ["string": "completed"]
//							let task = service.json(
//								method: .post,
//								path: "/api",
//								parameters: parameters,
//								interceptor: Interceptor()) { response in
//									expect(response.data).toNot(beNil())
//									expect(response.request).toNot(beNil())
//									expect(response.response).toNot(beNil())
//									expect(response.error).to(beNil())
//									expect(response.request?.httpMethod) == "POST"
//									expect(response.request?.url?.host) == "server.com"
//									expect(response.request?.url?.path) == "/api"
//									expect(response.request?.url?.query).to(beNil())
//									expect(response.request?.allHTTPHeaderFields).toNot(beNil())
//									expect(response.request?.allHTTPHeaderFields?.count) == 2
//									expect(response.request?.allHTTPHeaderFields?["Content-Type"]) == "application/json; charset=utf-8"
//									expect(response.request?.allHTTPHeaderFields?["dummy"]) == "dummy"
//									expect(response.request?.httpBody).toNot(beNil())
//									let body = try? JSONDecoder().decode(Parameters.self, from: response.request!.httpBody!)
//									expect(body).toNot(beNil())
//									expect(body?.string) == "completed"
//									expect(response.stringValue()).toNot(beNil())
//									expect(response.stringValue()) == "{\"string\":\"completed\"}"
//									let decodable = response.decodableValue(of: Parameters.self)
//									expect(decodable).toNot(beNil())
//									expect(decodable?.string) == "completed"
//									let dictionary = response.dictionaryValue()
//									expect(dictionary).toNot(beNil())
//									expect(dictionary?["string"] as? String) == "completed"
//									completed = true
//							}
//							expect(task).toNot(beNil())
//							expect(completed).toEventually(beTrue(), timeout: timeout)
//						}
//					}
//				}
		}
	}
}

// MARK: - Private helpers

private struct Person: Codable, Equatable {
    let name: String
}

private struct SimpleError: Codable, Error {
    let code: String
}

//private struct Parameters: Codable {
//	let string: String?
//	let int: Int?
//	let stringsList: [String]?
//	let intList: [Int]?
//}
//
//private struct Interceptor: RequestInterceptor {
//	func adapt(request: URLRequest) -> URLRequest {
//		var request = request
//		request.addValue("dummy", forHTTPHeaderField: "dummy")
//		return request
//	}
//}
