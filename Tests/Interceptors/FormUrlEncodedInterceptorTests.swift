import Foundation
import Quick
import Nimble
@testable import RestService

class FormUrlEncodedInterceptorTests: QuickSpec {
    override func spec() {
        
        var interceptor: FormUrlEncodedInterceptor!
        
        beforeEach {
            interceptor = FormUrlEncodedInterceptor()
        }
        
        describe("FormUrlEncodedInterceptor") {
            
            it("should have the correct header") {
                let url = URL(string: "http://www.google.com")!
                let request = interceptor.adapt(request: URLRequest(url: url))
                let headers = request.allHTTPHeaderFields
                let hasHeader = headers?.contains(where: {
                    $0.key == "Content-Type" && $0.value == "application/x-www-form-urlencoded"
                }) ?? false
                expect(hasHeader).to(beTrue())
            }
        }
    }
}
