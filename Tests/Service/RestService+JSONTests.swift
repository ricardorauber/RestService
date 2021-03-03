import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import RestService

class RestServiceJSONTests: QuickSpec {
    override func spec() {
        
        var service: RestService!
        let timeout: DispatchTimeInterval = .seconds(3)
        
        describe("RestService+JSON") {
            
            beforeEach {
                service = RestService(debug: true, host: "server.com")
                HTTPStubs.removeAllStubs()
                stub(condition: isHost("server.com")) { _ in
                    return HTTPStubsResponse(jsonObject: ["string": "completed"], statusCode: 200, headers: nil)
                }
            }
            
            context("Without parameters") {
            
                context("prepareJson") {
                    
                    it("should build a task for valid input") {
                        let task = service.prepareJson(
                            method: .post,
                            path: "/path",
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).toNot(beNil())
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.prepareJson(
                            method: .get,
                            path: "path",
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
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
                        let task = service.json(
                            method: .get,
                            path: "path",
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.json(
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
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.json(
                            method: .get,
                            path: "path",
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json<D: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
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
                        let task = service.json(
                            method: .get,
                            path: "path",
                            responseType: Person.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.json(
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
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.json(
                            method: .get,
                            path: "path",
                            responseType: Person.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json<E: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
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
                        let task = service.json(
                            method: .get,
                            path: "path",
                            customError: SimpleError.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.json(
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
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.json(
                            method: .get,
                            path: "path",
                            customError: SimpleError.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json<D: Decodable, E: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
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
                        let task = service.json(
                            method: .get,
                            path: "path",
                            responseType: Person.self,
                            customError: SimpleError.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.json(
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
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.json(
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
            
            context("Codable parameters") {
            
                context("prepareJson") {
                    
                    it("should build a task for valid input") {
                        let task = service.prepareJson(
                            method: .post,
                            path: "/path",
                            parameters: Person(name: "John"),
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).toNot(beNil())
                    }
                    
                    it("should not build a task for invalid input") {
                        let task = service.prepareJson(
                            method: .get,
                            path: "path",
                            parameters: Person(name: "John"),
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: Person(name: "John"),
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
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: Person(name: "John"),
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: Person(name: "John"),
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input without progress") {
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: Person(name: "John"),
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json<D: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: Person(name: "John"),
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
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: Person(name: "John"),
                            responseType: Person.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: Person(name: "John"),
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
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: Person(name: "John"),
                            responseType: Person.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json<E: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: Person(name: "John"),
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
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: Person(name: "John"),
                            customError: SimpleError.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: Person(name: "John"),
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
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: Person(name: "John"),
                            customError: SimpleError.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json<D: Decodable, E: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: Person(name: "John"),
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
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: Person(name: "John"),
                            responseType: Person.self,
                            customError: SimpleError.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: Person(name: "John"),
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
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: Person(name: "John"),
                            responseType: Person.self,
                            customError: SimpleError.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
            }
            
            context("Dictionary parameters") {
            
                context("prepareJson") {
                    
                    it("should build a task for valid input") {
                        let parameters: [String: Any] = ["name": "John"]
                        let task = service.prepareJson(
                            method: .post,
                            path: "/path",
                            parameters: parameters,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).toNot(beNil())
                    }
                    
                    it("should not build a task for invalid input") {
                        let parameters: [String: Any] = ["name": "John"]
                        let task = service.prepareJson(
                            method: .get,
                            path: "path",
                            parameters: parameters,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json") {
                    
                    it("should build a task for valid input with progress") {
                        let parameters: [String: Any] = ["name": "John"]
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: parameters,
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
                        let parameters: [String: Any] = ["name": "John"]
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: parameters,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        let parameters: [String: Any] = ["name": "John"]
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: parameters,
                            completion: { _ in
                                completed = true
                            }
                        )
                        expect(task).toNot(beNil())
                        task?.resume()
                        expect(completed).toEventually(beTrue(), timeout: timeout)
                        
                    }
                    
                    it("should not build a task for invalid input without progress") {
                        let parameters: [String: Any] = ["name": "John"]
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: parameters,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json<D: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        let parameters: [String: Any] = ["name": "John"]
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: parameters,
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
                        let parameters: [String: Any] = ["name": "John"]
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: parameters,
                            responseType: Person.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        let parameters: [String: Any] = ["name": "John"]
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: parameters,
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
                        let parameters: [String: Any] = ["name": "John"]
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: parameters,
                            responseType: Person.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json<E: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        let parameters: [String: Any] = ["name": "John"]
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: parameters,
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
                        let parameters: [String: Any] = ["name": "John"]
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: parameters,
                            customError: SimpleError.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        let parameters: [String: Any] = ["name": "John"]
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: parameters,
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
                        let parameters: [String: Any] = ["name": "John"]
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: parameters,
                            customError: SimpleError.self,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                }
                
                context("json<D: Decodable, E: Decodable>") {
                    
                    it("should build a task for valid input with progress") {
                        let parameters: [String: Any] = ["name": "John"]
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: parameters,
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
                        let parameters: [String: Any] = ["name": "John"]
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: parameters,
                            responseType: Person.self,
                            customError: SimpleError.self,
                            progress: nil,
                            completion: { _ in }
                        )
                        expect(task).to(beNil())
                    }
                    
                    it("should build a task for valid input without progress") {
                        let parameters: [String: Any] = ["name": "John"]
                        var completed = false
                        let task = service.json(
                            method: .post,
                            path: "/path",
                            parameters: parameters,
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
                        let parameters: [String: Any] = ["name": "John"]
                        let task = service.json(
                            method: .get,
                            path: "path",
                            parameters: parameters,
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
