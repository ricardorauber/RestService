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
        }
    }
}
