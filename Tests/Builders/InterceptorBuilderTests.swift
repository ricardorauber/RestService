import Foundation
import Quick
import Nimble
@testable import RestService

class InterceptorBuilderTests: QuickSpec {
    override func spec() {
        
        var builder: InterceptorBuilder!
        
        beforeEach {
            builder = InterceptorBuilder()
        }
        
        describe("InterceptorBuilder") {
            
            context("buildJson") {
                
                it("should build a group interceptor with a JSONInterceptor") {
                    let result = builder.buildJson() as? GroupInterceptor
                    expect(result).toNot(beNil())
                    expect(result?.interceptors.count) == 1
                    let first = result?.interceptors.first as? JSONInterceptor
                    expect(first).toNot(beNil())
                }
                
                it("should build a group interceptor with some other interceptor") {
                    let result = builder.buildJson(interceptor: FormDataInterceptor(boundary: "")) as? GroupInterceptor
                    expect(result).toNot(beNil())
                    expect(result?.interceptors.count) == 2
                    let first = result?.interceptors.first as? JSONInterceptor
                    expect(first).toNot(beNil())
                    let last = result?.interceptors.last as? FormDataInterceptor
                    expect(last).toNot(beNil())
                }
            }
            
            context("buildFormData") {
                
                it("should build a group interceptor with a FormDataInterceptor") {
                    let result = builder.buildFormData(boundary: "") as? GroupInterceptor
                    expect(result).toNot(beNil())
                    expect(result?.interceptors.count) == 1
                    let first = result?.interceptors.first as? FormDataInterceptor
                    expect(first).toNot(beNil())
                }
                
                it("should build a group interceptor with some other interceptor") {
                    let result = builder.buildFormData(boundary: "", interceptor: JSONInterceptor()) as? GroupInterceptor
                    expect(result).toNot(beNil())
                    expect(result?.interceptors.count) == 2
                    let first = result?.interceptors.first as? FormDataInterceptor
                    expect(first).toNot(beNil())
                    let last = result?.interceptors.last as? JSONInterceptor
                    expect(last).toNot(beNil())
                }
            }
        }
    }
}
