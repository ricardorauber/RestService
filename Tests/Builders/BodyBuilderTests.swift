import Foundation
import Quick
import Nimble
@testable import RestService

class BodyBuilderTests: QuickSpec {
    override func spec() {
        
        var builder: BodyBuilder!
        
        beforeEach {
            builder = BodyBuilder()
        }
        
        describe("BodyBuilder") {
            
            context("isAllowed") {
                
                it("should be true for allowed methods") {
                    expect(builder.isAllowed(method: .connect)).to(beTrue())
                    expect(builder.isAllowed(method: .options)).to(beTrue())
                    expect(builder.isAllowed(method: .patch)).to(beTrue())
                    expect(builder.isAllowed(method: .post)).to(beTrue())
                    expect(builder.isAllowed(method: .put)).to(beTrue())
                    expect(builder.isAllowed(method: .trace)).to(beTrue())
                }
                
                it("should be false for not allowed methods") {
                    expect(builder.isAllowed(method: .get)).to(beFalse())
                    expect(builder.isAllowed(method: .head)).to(beFalse())
                    expect(builder.isAllowed(method: .delete)).to(beFalse())
                }
            }
            
            context("buildJson") {
                
                context("codable") {
                    
                    it("should be nil for a not allowed method") {
                        let parameters = Person(name: "John")
                        let data = builder.buildJson(method: .get, parameters: parameters)
                        expect(data).to(beNil())
                    }
                    
                    it("should create a Data value for an allowed method") {
                        let parameters = Person(name: "John")
                        let data = builder.buildJson(method: .post, parameters: parameters)
                        expect(data).toNot(beNil())
                    }
                }
                
                context("dictionary") {
                    
                    it("should be nil for a not allowed method") {
                        let method: HTTPMethod = .get
                        let parameters: [String: Any] = ["name": "John"]
                        let data = builder.buildJson(method: method, parameters: parameters)
                        expect(data).to(beNil())
                    }
                    
                    it("should create a Data value for an allowed method") {
                        let method: HTTPMethod = .post
                        let parameters: [String: Any] = ["name": "John"]
                        let data = builder.buildJson(method: method, parameters: parameters)
                        expect(data).toNot(beNil())
                    }
                }
            }
            
            context("buildFormData") {
                
                it("should be nil for a not allowed method") {
                    let method: HTTPMethod = .get
                    let boundary = UUID().uuidString
                    let parameters: [FormDataParameter] = [
                        TextFormDataParameter(name: "email", value: "a@s.com")
                    ]
                    let data = builder.buildFormData(method: method, boundary: boundary, parameters: parameters)
                    expect(data).to(beNil())
                }
                
                it("should be nil for an empty boundary") {
                    let method: HTTPMethod = .post
                    let boundary = ""
                    let parameters: [FormDataParameter] = [
                        TextFormDataParameter(name: "email", value: "a@s.com")
                    ]
                    let data = builder.buildFormData(method: method, boundary: boundary, parameters: parameters)
                    expect(data).to(beNil())
                }
                
                it("should be nil for an empty list of parameters") {
                    let method: HTTPMethod = .post
                    let boundary = UUID().uuidString
                    let parameters: [FormDataParameter] = []
                    let data = builder.buildFormData(method: method, boundary: boundary, parameters: parameters)
                    expect(data).to(beNil())
                }
                
                it("should create a Data value for a valid call") {
                    let method: HTTPMethod = .post
                    let boundary = UUID().uuidString
                    let parameters: [FormDataParameter] = [
                        TextFormDataParameter(name: "email", value: "a@s.com")
                    ]
                    let data = builder.buildFormData(method: method, boundary: boundary, parameters: parameters)
                    expect(data).toNot(beNil())
                }
            }
            
            context("buildFormUrlEncoded") {
                
                context("codable") {
                    
                    it("should be nil for a not allowed method") {
                        let parameters = Person(name: "John")
                        let data = builder.buildFormUrlEncoded(method: .get, parameters: parameters)
                        expect(data).to(beNil())
                    }
                    
                    it("should create a Data value for an allowed method") {
                        let parameters = Person(name: "John")
                        let data = builder.buildFormUrlEncoded(method: .post, parameters: parameters)
                        expect(data).toNot(beNil())
                    }
                }
                
                context("dictionary") {
                    
                    it("should be nil for a not allowed method") {
                        let method: HTTPMethod = .get
                        let parameters: [String: Any] = ["name": "John"]
                        let data = builder.buildFormUrlEncoded(method: method, parameters: parameters)
                        expect(data).to(beNil())
                    }
                    
                    it("should create a Data value for an allowed method") {
                        let method: HTTPMethod = .post
                        let parameters: [String: Any] = ["name": "John"]
                        let data = builder.buildFormUrlEncoded(method: method, parameters: parameters)
                        expect(data).toNot(beNil())
                    }
                }
            }
        }
    }
}

// MARK: - Test Helpers
private struct Person: Codable {
    let name: String
}
