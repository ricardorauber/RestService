import Foundation
import Quick
import Nimble
@testable import RestService

class FormDataInterceptorTests: QuickSpec {
    override func spec() {
        
        let boundary = "abc"
        var interceptor: FormDataInterceptor!
        
        beforeEach {
            interceptor = FormDataInterceptor(boundary: boundary)
        }
        
        describe("FormDataInterceptor") {
            
            it("should have the correct header") {
                let url = URL(string: "http://www.google.com")!
                let request = interceptor.adapt(request: URLRequest(url: url))
                let headers = request.allHTTPHeaderFields
                let hasHeader = headers?.contains(where: {
                    $0.key == "Content-Type" && $0.value == "multipart/form-data; boundary=abc"
                }) ?? false
                expect(hasHeader).to(beTrue())
            }
        }
    }
}
