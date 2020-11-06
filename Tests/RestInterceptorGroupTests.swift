import Foundation
import Quick
import Nimble
import OHHTTPStubs
@testable import RestService

class RestInterceptorGroupTests: QuickSpec {
    override func spec() {
        
        var interceptor: RestInterceptorGroup!
        
        beforeEach {
            interceptor = RestInterceptorGroup(interceptors: [
                APIKeyInterceptor(),
                TokenInterceptor()
            ])
        }
        
        describe("RestInterceptorGroup") {
            
            it("should have all the adapted data from the interceptors") {
                let url = URL(string: "http://www.google.com")!
                let request = interceptor.adapt(request: URLRequest(url: url))
                let headers = request.allHTTPHeaderFields
                let hasApiKey = headers?.contains(where: {
                    $0.key == "X-API-KEY" && $0.value == "123"
                }) ?? false
                expect(hasApiKey).to(beTrue())
                let hasToken = headers?.contains(where: {
                    $0.key == "Authorization" && $0.value == "Bearer ABC"
                }) ?? false
                expect(hasToken).to(beTrue())
            }
        }
    }
}

// MARK: - Test Helpers

private struct APIKeyInterceptor: RestRequestInterceptor {
    func adapt(request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("123", forHTTPHeaderField: "X-API-KEY")
        return request
    }
}

private struct TokenInterceptor: RestRequestInterceptor {
    func adapt(request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("Bearer ABC", forHTTPHeaderField: "Authorization")
        return request
    }
}
