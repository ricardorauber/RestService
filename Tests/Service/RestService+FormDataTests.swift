import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import RestService

class RestServiceFormDataTests: QuickSpec {
    override func spec() {
        
        var service: RestService!
        let timeout: TimeInterval = 3
        
        describe("RestService+FormData") {
            
            beforeEach {
                service = RestService(host: "server.com")
                HTTPStubs.removeAllStubs()
                stub(condition: isHost("server.com")) { _ in
                    return HTTPStubsResponse(jsonObject: ["string": "completed"], statusCode: 200, headers: nil)
                }
            }
            
            context("prepareFormData") {
                
                it("should build a task for valid input") {
                    let task = service.prepareFormData(
                        method: .post,
                        path: "/path",
                        parameters: [
                            TextFormDataParameter(name: "user", value: "john")
                        ],
                        interceptor: nil,
                        progress: nil,
                        completion: { _ in }
                    )
                    expect(task).toNot(beNil())
                }
                
                it("should not build a task for invalid input") {
                    let task = service.prepareFormData(
                        method: .get,
                        path: "path",
                        parameters: [],
                        interceptor: nil,
                        progress: nil,
                        completion: { _ in }
                    )
                    expect(task).to(beNil())
                }
            }
            
            context("formData") {
                
                it("should build a task for valid input") {
                    var completed = false
                    let task = service.formData(
                        method: .post,
                        path: "/path",
                        parameters: [
                            TextFormDataParameter(name: "user", value: "john")
                        ],
                        interceptor: nil,
                        progress: nil,
                        completion: { _ in
                            completed = true
                        }
                    )
                    expect(task).toNot(beNil())
                    task?.resume()
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                    
                }
                
                it("should not build a task for invalid input") {
                    let task = service.formData(
                        method: .get,
                        path: "path",
                        parameters: [],
                        interceptor: nil,
                        progress: nil,
                        completion: { _ in }
                    )
                    expect(task).to(beNil())
                }
            }
            
            context("formData<D: Decodable>") {
                
                it("should build a task for valid input") {
                    var completed = false
                    let task = service.formData(
                        method: .post,
                        path: "/path",
                        parameters: [
                            TextFormDataParameter(name: "user", value: "john")
                        ],
                        interceptor: nil,
                        responseType: Person.self,
                        progress: nil,
                        completion: { _ in
                            completed = true
                        }
                    )
                    expect(task).toNot(beNil())
                    task?.resume()
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                    
                }
                
                it("should not build a task for invalid input") {
                    let task = service.formData(
                        method: .get,
                        path: "path",
                        parameters: [],
                        interceptor: nil,
                        responseType: Person.self,
                        progress: nil,
                        completion: { _ in }
                    )
                    expect(task).to(beNil())
                }
            }
            
            context("formData<E: Decodable>") {
                
                it("should build a task for valid input") {
                    var completed = false
                    let task = service.formData(
                        method: .post,
                        path: "/path",
                        parameters: [
                            TextFormDataParameter(name: "user", value: "john")
                        ],
                        interceptor: nil,
                        customError: SimpleError.self,
                        progress: nil,
                        completion: { _ in
                            completed = true
                        }
                    )
                    expect(task).toNot(beNil())
                    task?.resume()
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                    
                }
                
                it("should not build a task for invalid input") {
                    let task = service.formData(
                        method: .get,
                        path: "path",
                        parameters: [],
                        interceptor: nil,
                        customError: SimpleError.self,
                        progress: nil,
                        completion: { _ in }
                    )
                    expect(task).to(beNil())
                }
            }
            
            context("formData<D: Decodable, E: Decodable>") {
                
                it("should build a task for valid input") {
                    var completed = false
                    let task = service.formData(
                        method: .post,
                        path: "/path",
                        parameters: [
                            TextFormDataParameter(name: "user", value: "john")
                        ],
                        interceptor: nil,
                        responseType: Person.self,
                        customError: SimpleError.self,
                        progress: nil,
                        completion: { _ in
                            completed = true
                        }
                    )
                    expect(task).toNot(beNil())
                    task?.resume()
                    expect(completed).toEventually(beTrue(), timeout: timeout)
                    
                }
                
                it("should not build a task for invalid input") {
                    let task = service.formData(
                        method: .get,
                        path: "path",
                        parameters: [],
                        interceptor: nil,
                        responseType: Person.self,
                        customError: SimpleError.self,
                        progress: nil,
                        completion: { _ in }
                    )
                    expect(task).to(beNil())
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
