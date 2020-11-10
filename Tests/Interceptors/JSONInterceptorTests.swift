import Foundation
import Quick
import Nimble
@testable import RestService

class JSONInterceptorTests: QuickSpec {
    override func spec() {
        
        var interceptor: JSONInterceptor!
        
        beforeEach {
            interceptor = JSONInterceptor()
        }
        
        describe("JSONInterceptor") {
            
            it("should have the correct header") {
                let url = URL(string: "http://www.google.com")!
                let request = interceptor.adapt(request: URLRequest(url: url))
                let headers = request.allHTTPHeaderFields
                let hasHeader = headers?.contains(where: {
                    $0.key == "Content-Type" && $0.value == "application/json; charset=utf-8"
                }) ?? false
                expect(hasHeader).to(beTrue())
            }
        }
    }
}
