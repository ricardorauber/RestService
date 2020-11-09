import Foundation
import Quick
import Nimble
@testable import RestService

class RequestBuilderTests: QuickSpec {
    override func spec() {
        
        var builder: RequestBuilder!
        
        beforeEach {
            builder = RequestBuilder()
        }
        
        describe("RequestBuilder") {
            
            context("build") {
                
                it("should not build a request with invalid input") {
                    let request = builder.build(host: "", path: "bla")
                    expect(request).to(beNil())
                }
                
                it("should build a simple request") {
                    let scheme: HTTPScheme = .https
                    let method: HTTPMethod = .get
                    let host = "server.com"
                    let path = "/path"
                    
                    let request = builder.build(
                        scheme: scheme,
                        method: method,
                        host: host,
                        path: path)
                    
                    expect(request).toNot(beNil())
                }
                
                it("should build a full request") {
                    let scheme: HTTPScheme = .https
                    let method: HTTPMethod = .get
                    let host = "server.com"
                    let path = "/path"
                    let port = 8080
                    let queryItems: [URLQueryItem] = [
                        URLQueryItem(name: "q", value: "query")
                    ]
                    let body = "body".data(using: .utf8)
                    let interceptor = JSONInterceptor()
                    
                    let request = builder.build(
                        scheme: scheme,
                        method: method,
                        host: host,
                        path: path,
                        port: port,
                        queryItems: queryItems,
                        body: body,
                        interceptor: interceptor)
                    
                    expect(request).toNot(beNil())
                }
            }
        }
    }
}
