import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import RestService

class RestServiceTests: QuickSpec {
	override func spec() {

		var service: RestService!

		describe("RestService") {
			
			beforeEach {
                service = RestService(debug: true, host: "server.com")
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
            
            context("integration") {
                
                var completed: Bool!
                var task: RestTask!
                var timeout: TimeInterval!
                
                beforeEach {
                    completed = false
                    service = RestService(debug: true, host: "api.github.com")
                    timeout = 3
                }
                
                it("should get a valid response") {
                    service = RestService(debug: true, host: "github.com")
                    task = service.json(
                        method: .get,
                        path: "/ricardorauber/RestService",
                        interceptor: nil,
                        progress: nil,
                        completion: { response in
                            completed = true
                            expect(task.response?.statusCode) < 300
                        }
                    )
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
                
                it("should get an error from the server") {
                    var task: RestTask!
                    task = service.json(
                        method: .get,
                        path: "/thisisanicetest",
                        interceptor: nil,
                        progress: nil,
                        completion: { response in
                            completed = true
                            expect(task.response?.statusCode) >= 400
                        }
                    )
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
                
                it("should get an error from a local error") {
                    task = service.json(
                        method: .get,
                        path: "/thisisanicetest",
                        interceptor: nil,
                        progress: nil,
                        completion: { response in
                            completed = true
                            expect(task.response?.statusCode) == -1
                        }
                    )
                    task.cancel()
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
            }
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
