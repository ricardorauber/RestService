import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import RestService

class RestServiceRequestTests: QuickSpec {
    override func spec() {
        
        var service: RestService!
        let timeout: DispatchTimeInterval = .seconds(3)
        
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
                            completion: { _ in }
                        )
                        expect(task).toNot(beNil())
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.prepareRequest(
                            method: .get,
                            path: "path",
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request") {
                    
                    it("should build a task for valid input") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<D: Decodable>") {
                    
                    it("should build a task for valid input") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            responseType: Person.self,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            responseType: Person.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<E: Decodable & Error>") {
                    
                    it("should build a task for valid input") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            customError: SimpleError.self,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            customError: SimpleError.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<D: Decodable, E: Decodable>") {
                    
                    it("should build a task for valid input") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
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
                    
                    it("should not build a task for invalid input") {
                        let task = service.request(
                            method: .get,
                            path: "path",
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
                            completion: { _ in }
                        )
                        expect(task).toNot(beNil())
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.prepareRequest(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request") {
                    
                    it("should build a task for valid input") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<D: Decodable>") {
                    
                    it("should build a task for valid input") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
                            responseType: Person.self,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            responseType: Person.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<E: Decodable & Error>") {
                    
                    it("should build a task for valid input") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
                            customError: SimpleError.self,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
                            customError: SimpleError.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("request<D: Decodable, E: Decodable>") {
                    
                    it("should build a task for valid input") {
                        var completed = false
                        let task = service.request(
                            method: .post,
                            path: "/path",
                            body: "John".data(using: .utf8)!,
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
                    
                    it("should not build a task for invalid input") {
                        let task = service.request(
                            method: .get,
                            path: "path",
                            body: "John".data(using: .utf8)!,
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
