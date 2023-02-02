import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import RestService

class ResultConvertibleTests: QuickSpec {
    override func spec() {
        
        var service: RestService!
        let timeout: DispatchTimeInterval = .seconds(3)
        
        describe("ResultConvertible") {
            
            beforeEach {
                HTTPStubs.removeAllStubs()
                service = RestService(debug: true, host: "server.com")
            }
            
            context("RestTaskResult") {
                
                it("should convert to Result with success") {
                    stub(condition: isHost("server.com")) { _ in
                        return HTTPStubsResponse(jsonObject: ["string": "completed"], statusCode: 200, headers: nil)
                    }
                    var completed = false
                    let task = service.json(method: .get,
                                            path: "") { response in
                        let result = response.result
                        switch result {
                        case .success():
                            break
                        default:
                            fail()
                        }
                        completed = true
                    }
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
                
                it("should convert to Result with failure") {
                    stub(condition: isHost("server.com")) { _ in
                        return HTTPStubsResponse(error: RestServiceError.unknown)
                    }
                    var completed = false
                    let task = service.json(method: .get,
                                            path: "") { response in
                        let result = response.result
                        switch result {
                        case .failure(_):
                            break
                        default:
                            fail()
                        }
                        completed = true
                    }
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
            }
            
            context("RestTaskResultWithCustomError") {
                
                it("should convert to Result with success") {
                    stub(condition: isHost("server.com")) { _ in
                        return HTTPStubsResponse(jsonObject: ["string": "completed"], statusCode: 200, headers: nil)
                    }
                    var completed = false
                    let task = service.json(method: .get,
                                            path: "",
                                            customError: ServerError.self) { response in
                        let result = response.result
                        switch result {
                        case .success:
                            break
                        default:
                            fail()
                        }
                        completed = true
                    }
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
                
                it("should convert to Result with failure from custom error") {
                    stub(condition: isHost("server.com")) { _ in
                        return HTTPStubsResponse(jsonObject: ["error": "unknown"], statusCode: 200, headers: nil)
                    }
                    var completed = false
                    let task = service.json(method: .get,
                                            path: "",
                                            customError: ServerError.self) { response in
                        let result = response.result
                        switch result {
                        case .failure(let error):
                            if let _ = error as? ServerError {
                                break
                            }
                            fail()
                        default:
                            fail()
                        }
                        completed = true
                    }
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
                
                it("should convert to Result with failure") {
                    stub(condition: isHost("server.com")) { _ in
                        return HTTPStubsResponse(error: RestServiceError.unknown)
                    }
                    var completed = false
                    let task = service.json(method: .get,
                                            path: "",
                                            customError: ServerError.self) { response in
                        let result = response.result
                        switch result {
                        case .failure(_):
                            break
                        default:
                            fail()
                        }
                        completed = true
                    }
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
            }
            
            context("RestTaskResultWithData") {
                
                it("should convert to Result with success") {
                    stub(condition: isHost("server.com")) { _ in
                        let response: [String: Codable] = [
                            "name": "Steve",
                            "age": 50
                        ]
                        return HTTPStubsResponse(jsonObject: response, statusCode: 200, headers: nil)
                    }
                    var completed = false
                    let task = service.json(method: .get,
                                            path: "",
                                            responseType: Person.self) { response in
                        let result = response.result
                        switch result {
                        case .success(_):
                            break
                        default:
                            fail()
                        }
                        completed = true
                    }
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
                
                it("should convert to Result with failure") {
                    stub(condition: isHost("server.com")) { _ in
                        return HTTPStubsResponse(error: RestServiceError.unknown)
                    }
                    var completed = false
                    let task = service.json(method: .get,
                                            path: "",
                                            responseType: Person.self) { response in
                        let result = response.result
                        switch result {
                        case .failure(_):
                            break
                        default:
                            fail()
                        }
                        completed = true
                    }
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
            }
            
            context("RestTaskResultWithDataAndCustomError") {
                
                it("should convert to Result with success") {
                    stub(condition: isHost("server.com")) { _ in
                        let response: [String: Codable] = [
                            "name": "Steve",
                            "age": 50
                        ]
                        return HTTPStubsResponse(jsonObject: response, statusCode: 200, headers: nil)
                    }
                    var completed = false
                    let task = service.json(method: .get,
                                            path: "",
                                            responseType: Person.self,
                                            customError: ServerError.self) { response in
                        let result = response.result
                        switch result {
                        case .success(_):
                            break
                        default:
                            fail()
                        }
                        completed = true
                    }
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
                
                it("should convert to Result with failure from custom error") {
                    stub(condition: isHost("server.com")) { _ in
                        return HTTPStubsResponse(jsonObject: ["error": "unknown"], statusCode: 200, headers: nil)
                    }
                    var completed = false
                    let task = service.json(method: .get,
                                            path: "",
                                            responseType: Person.self,
                                            customError: ServerError.self) { response in
                        let result = response.result
                        switch result {
                        case .failure(let error):
                            if let _ = error as? ServerError {
                                break
                            }
                            fail()
                        default:
                            fail()
                        }
                        completed = true
                    }
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
                
                it("should convert to Result with failure") {
                    stub(condition: isHost("server.com")) { _ in
                        return HTTPStubsResponse(error: RestServiceError.unknown)
                    }
                    var completed = false
                    let task = service.json(method: .get,
                                            path: "",
                                            responseType: Person.self,
                                            customError: ServerError.self) { response in
                        let result = response.result
                        switch result {
                        case .failure(_):
                            break
                        default:
                            fail()
                        }
                        completed = true
                    }
                    expect(task).toNot(beNil())
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                }
            }
        }
    }
}

// MARK: - Test Helpers
private struct Person: Codable {
    let name: String
    let age: Int
}

private struct ServerError: Codable, Error {
    let error: String
}
