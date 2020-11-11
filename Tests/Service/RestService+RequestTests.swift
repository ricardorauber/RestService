import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import RestService

class RestServiceRequestTests: QuickSpec {
    override func spec() {
        
        var service: RestService!
        let timeout: TimeInterval = 3
        
        describe("RestService+Request") {
            
            beforeEach {
                service = RestService(debug: true, host: "server.com")
                HTTPStubs.removeAllStubs()
                stub(condition: isHost("server.com")) { _ in
                    return HTTPStubsResponse(jsonObject: ["string": "completed"], statusCode: 200, headers: nil)
                }
            }
            
            context("Without body") {
            
                context("prepareRequest") {
                    
                    it("should build a task for valid input") {
                        let task = service.prepareRequest(
                            method: .post,
                            path: "/path",
                            interceptor: nil,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).toNot(beNil())
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.prepareRequest(
                            method: .get,
                            path: "path",
                            interceptor: nil,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
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
                    
                    it("should not build a task for invalid input with progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            interceptor: nil,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            interceptor: nil,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            interceptor: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<D: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
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
                    
                    it("should not build a task for invalid input with progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            interceptor: nil,
                            responseType: Person.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            interceptor: nil,
                            responseType: Person.self,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            interceptor: nil,
                            responseType: Person.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<E: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
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
                    
                    it("should not build a task for invalid input with progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            interceptor: nil,
                            customError: SimpleError.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            interceptor: nil,
                            customError: SimpleError.self,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            interceptor: nil,
                            customError: SimpleError.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<D: Decodable, E: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
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
                    
                    it("should not build a task for invalid input with progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            interceptor: nil,
                            responseType: Person.self,
                            customError: SimpleError.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            interceptor: nil,
                            responseType: Person.self,
                            customError: SimpleError.self,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            interceptor: nil,
                            responseType: Person.self,
                            customError: SimpleError.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
            }
            
            context("With body") {
            
                context("prepareRequest") {
                    
                    it("should build a task for valid input") {
                        let task = service.prepareRequest(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).toNot(beNil())
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.prepareRequest(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
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
                    
                    it("should not build a task for invalid input with progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<D: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
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
                    
                    it("should not build a task for invalid input with progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            responseType: Person.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            responseType: Person.self,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            responseType: Person.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<E: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
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
                    
                    it("should not build a task for invalid input with progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            customError: SimpleError.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            customError: SimpleError.self,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            customError: SimpleError.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<D: Decodable, E: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
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
                    
                    it("should not build a task for invalid input with progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            responseType: Person.self,
                            customError: SimpleError.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            responseType: Person.self,
                            customError: SimpleError.self,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            interceptor: nil,
                            responseType: Person.self,
                            customError: SimpleError.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
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
