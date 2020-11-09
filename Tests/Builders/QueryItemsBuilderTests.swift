import Foundation
import Quick
import Nimble
@testable import RestService

class QueryItemsBuilderTests: QuickSpec {
    override func spec() {
        
        var builder: QueryItemsBuilder!
        
        beforeEach {
            builder = QueryItemsBuilder()
        }
        
        describe("QueryItemsBuilder") {
            
            context("isAllowed") {
                
                it("should be false for not allowed methods") {
                    expect(builder.isAllowed(method: .connect)).to(beFalse())
                    expect(builder.isAllowed(method: .options)).to(beFalse())
                    expect(builder.isAllowed(method: .patch)).to(beFalse())
                    expect(builder.isAllowed(method: .post)).to(beFalse())
                    expect(builder.isAllowed(method: .put)).to(beFalse())
                    expect(builder.isAllowed(method: .trace)).to(beFalse())
                }
                
                it("should be true for allowed methods") {
                    expect(builder.isAllowed(method: .get)).to(beTrue())
                    expect(builder.isAllowed(method: .head)).to(beTrue())
                    expect(builder.isAllowed(method: .delete)).to(beTrue())
                }
            }
            
            context("build") {
                
                context("codable") {
                    
                    it("should not build for a not allowed method") {
                        let method: HTTPMethod = .post
                        let parameters = Person(name: "john")
                        let queryItems = builder.build(method: method, parameters: parameters)
                        expect(queryItems).to(beNil())
                    }
                    
                    it("should not build for a non dictionary value") {
                        let method: HTTPMethod = .get
                        let parameters = 10
                        let queryItems = builder.build(method: method, parameters: parameters)
                        expect(queryItems).to(beNil())
                    }
                    
                    it("should build a list of query items with valid input") {
                        let method: HTTPMethod = .get
                        let parameters = Person(name: "john")
                        let queryItems = builder.build(method: method, parameters: parameters)
                        expect(queryItems).toNot(beNil())
                        expect(queryItems?.count) == 1
                    }
                }
                
                context("dictionary") {
                    
                    it("should not build for a not allowed method") {
                        let method: HTTPMethod = .post
                        let parameters: [String: Any] = ["name": "john"]
                        let queryItems = builder.build(method: method, parameters: parameters)
                        expect(queryItems).to(beNil())
                    }
                    
                    it("should build a list of query items with valid input") {
                        let method: HTTPMethod = .get
                        let parameters: [String: Any] = [
                            "name": "john",
                            "numbers": [1, 2, 3]
                        ]
                        let queryItems = builder.build(method: method, parameters: parameters)
                        expect(queryItems).toNot(beNil())
                        expect(queryItems?.count) == 4
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
