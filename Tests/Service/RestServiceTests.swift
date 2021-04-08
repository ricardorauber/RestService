import Foundation
import Quick
import Nimble
@testable import RestService

class RestServiceTests: QuickSpec {
	override func spec() {

		var service: RestService!

		describe("RestService") {
			
			beforeEach {
                service = RestService(debug: true, host: "server.com")
                service.encoder = JSONEncoder()
                service.decoder = JSONDecoder()
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
    
                it("should create an instance from an URL") {
                    let url = URL(string: "https://server.com:3000")!
                    service = RestService(url: url)
                    expect(service.scheme) == .https
					expect(service.host) == "server.com"
					expect(service.port) == 3000
                    expect(service.startTasksAutomatically).to(beTrue())
                }
    
                it("should create an instance from an invalid URL") {
                    service = RestService(url: nil)
                    expect(service.scheme) == .https
					expect(service.host) == ""
					expect(service.port).to(beNil())
                    expect(service.startTasksAutomatically).to(beTrue())
                }
    
                it("should create an instance from a string URL") {
                    service = RestService(url: "https://server.com:3000")
                    expect(service.scheme) == .https
					expect(service.host) == "server.com"
					expect(service.port) == 3000
                    expect(service.startTasksAutomatically).to(beTrue())
                }
    
                it("should create an instance from a string URL without scheme and host") {
                    let url = "//:3000"
                    service = RestService(url: url, startTasksAutomatically: false)
                    expect(service.scheme) == .https
					expect(service.host) == ""
					expect(service.port) == 3000
                    expect(service.startTasksAutomatically).to(beFalse())
                }
    
                it("should create an instance from an invalid string URL") {
                    service = RestService(url: "")
                    expect(service.scheme) == .https
					expect(service.host) == ""
					expect(service.port).to(beNil())
                    expect(service.startTasksAutomatically).to(beTrue())
                }
			}
            
            context("fullPath") {
                
                it("should have a path without base path") {
                    service = RestService(debug: true, host: "server.com")
                    let result = service.fullPath(with: "/users")
                    expect(result) == "/users"
                }
                
                it("should have a full path with base path and path") {
                    service = RestService(debug: true, host: "server.com", basePath: "/api/v1")
                    let result = service.fullPath(with: "/users")
                    expect(result) == "/api/v1/users"
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
                    let result = service.prepare(response: response)
                    switch result {
                    case .success:
                        break
                    default:
                        fail()
                    }
                }
                
                it("should be failure for a response with error") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: RestServiceError.unknown)
                    let result = service.prepare(response: response)
                    switch result {
                    case .failure(_):
                        break
                    default:
                        fail()
                    }
                }
                
                it("should be failure for an invalid empty response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response)
                    switch result {
                    case .failure(_):
                        break
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
                    let object = "mark"
                    let data = object.data(using: .utf8)
                    let response = RestResponse(data: data, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response)
                    switch result {
                    case .failure(_):
                        break
                    default:
                        fail()
                    }
                }
            }
            
            context("prepare<D: Decodable>") {
                
                it("should be success for a valid json object") {
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
                
                it("should be success for a valid data") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object = "mark"
                    let data = object.data(using: .utf8)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Data.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == data
                    default:
                        fail()
                    }
                }
                
                it("should be success for a valid string") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object = "mark"
                    let data = object.data(using: .utf8)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: String.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == object
                    default:
                        fail()
                    }
                }
                
                it("should be success for a valid int") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object: Int = 10
                    let data = "\(object)".data(using: .utf8)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Int.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == object
                    default:
                        fail()
                    }
                }
                
                it("should be success for a valid float") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object: Float = 10.5
                    let data = "\(object)".data(using: .utf8)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Float.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == object
                    default:
                        fail()
                    }
                }
                
                it("should be success for a valid double") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object: Double = 10.5
                    let data = "\(object)".data(using: .utf8)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Double.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == object
                    default:
                        fail()
                    }
                }
                
                it("should be failure for a response with error") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: RestServiceError.unknown)
                    let result = service.prepare(response: response, responseType: Person.self)
                    switch result {
                    case .failure(_):
                        break
                    default:
                        fail()
                    }
                }
                
                it("should be failure for an invalid empty response") {
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
                
                it("should be failure for an invalid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
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
                
                it("should be failure for an invalid object in a valid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object: [String: Int] = [
                        "name": 1
                    ]
                    let data = try? service.encoder.encode(object)
                    let response = RestResponse(data: data, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Person.self)
                    switch result {
                    case .failure:
                        break
                    default:
                        fail()
                    }
                }
                
                it("should be failure for an invalid object in an invalid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object: [String: Int] = [
                        "name": 1
                    ]
                    let data = try? service.encoder.encode(object)
                    let response = RestResponse(data: data, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Person.self)
                    switch result {
                    case .failure:
                        break
                    default:
                        fail()
                    }
                }
            }
            
            context("prepare<E: Decodable & Error>") {
                
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
                
                it("should be failure for a response with error") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: RestServiceError.unknown)
                    let result = service.prepare(response: response, customError: SimpleError.self)
                    switch result {
                    case .failure(_):
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
                
                it("should be failure for an invalid empty response") {
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
                
                it("should be failure for an invalid object in an invalid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object: [String: Int] = [
                        "name": 1
                    ]
                    let data = try? service.encoder.encode(object)
                    let response = RestResponse(data: data, request: nil, response: urlResponse, error: nil)
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
                
                it("should be success for a valid json object") {
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
                
                it("should be success for a valid data") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object = "mark"
                    let data = object.data(using: .utf8)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Data.self, customError: SimpleError.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == data
                    default:
                        fail()
                    }
                }
                
                it("should be success for a valid string") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object = "mark"
                    let data = object.data(using: .utf8)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: String.self, customError: SimpleError.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == object
                    default:
                        fail()
                    }
                }
                
                it("should be success for a valid int") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object: Int = 10
                    let data = "\(object)".data(using: .utf8)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Int.self, customError: SimpleError.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == object
                    default:
                        fail()
                    }
                }
                
                it("should be success for a valid float") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object: Float = 10.5
                    let data = "\(object)".data(using: .utf8)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Float.self, customError: SimpleError.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == object
                    default:
                        fail()
                    }
                }
                
                it("should be success for a valid double") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object: Double = 10.5
                    let data = "\(object)".data(using: .utf8)
                    let response = RestResponse(data: data!, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Double.self, customError: SimpleError.self)
                    switch result {
                    case .success(let responseObject):
                        expect(responseObject) == object
                    default:
                        fail()
                    }
                }
                
                it("should be failure for a response with error") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let response = RestResponse(data: nil, request: nil, response: urlResponse, error: RestServiceError.unknown)
                    let result = service.prepare(response: response, responseType: Person.self, customError: SimpleError.self)
                    switch result {
                    case .failure(_):
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
                    let result = service.prepare(response: response, responseType: Person.self, customError: SimpleError.self)
                    switch result {
                    case .customError(let responseObject):
                        expect(responseObject.code) == object.code
                    default:
                        fail()
                    }
                }
                
                it("should be failure for an invalid empty response") {
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
                
                it("should be failure for an invalid object in a valid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 200,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object: [String: Int] = [
                        "name": 1
                    ]
                    let data = try? service.encoder.encode(object)
                    let response = RestResponse(data: data, request: nil, response: urlResponse, error: nil)
                    let result = service.prepare(response: response, responseType: Person.self, customError: SimpleError.self)
                    switch result {
                    case .failure:
                        break
                    default:
                        fail()
                    }
                }
                
                it("should be failure for an invalid object in an invalid response") {
                    let url = URL(string: "https://server.com")!
                    let urlResponse = HTTPURLResponse(
                        url: url,
                        statusCode: 400,
                        httpVersion: nil,
                        headerFields: nil
                    )
                    let object: [String: Int] = [
                        "name": 1
                    ]
                    let data = try? service.encoder.encode(object)
                    let response = RestResponse(data: data, request: nil, response: urlResponse, error: nil)
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
                let timeout: DispatchTimeInterval = .seconds(3)
                
                beforeEach {
                    completed = false
                    service = RestService(debug: true, host: "api.github.com")
                }
                
                it("should get a valid response") {
                    service = RestService(debug: true, host: "github.com")
                    task = service.json(
                        method: .get,
                        path: "/ricardorauber/RestService",
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
