import Foundation
import Quick
import Nimble
@testable import RestService

class RestServiceErrorTests: QuickSpec {
    override func spec() {
        
        var error: RestServiceError!
        
        describe("RestServiceError") {
            
            context("init") {
                
                it("should have an error message") {
                    error = RestServiceError("something")
                    expect(error.error) == "something"
                }
                
                it("should have a localized error message") {
                    error = RestServiceError("something")
                    expect(error.errorDescription) == "something"
                }
            }
            
            context("equatable") {
            
                it("should be equal to the same one") {
                    let error1 = RestServiceError.unknown
                    let error2 = RestServiceError.unknown
                    let result = error1 == error2
                    expect(result).to(beTrue())
                }
            }
        }
    }
}
