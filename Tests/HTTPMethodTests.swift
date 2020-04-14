import Quick
import Nimble
@testable import RestService

class HTTPMethodTests: QuickSpec {
	override func spec() {
		
		describe("HTTPMethod") {
			
			context("equality") {
				
				it("same methods should be true") {
					let method1: HTTPMethod = .get
					let method2: HTTPMethod = .get
					expect(method1 == method2).to(beTrue())
				}
				
				it("different methods should be false") {
					let method1: HTTPMethod = .get
					let method2: HTTPMethod = .post
					expect(method1 == method2).to(beFalse())
				}
			}
			
			context("difference") {
				
				it("same methods should be false") {
					let method1: HTTPMethod = .get
					let method2: HTTPMethod = .get
					expect(method1 != method2).to(beFalse())
				}
				
				it("different methods should be true") {
					let method1: HTTPMethod = .get
					let method2: HTTPMethod = .post
					expect(method1 != method2).to(beTrue())
				}
			}
			
			context("default values") {
				
				it("should have the CONNECT method") {
					let method: HTTPMethod = .connect
					expect(method.rawValue) == "CONNECT"
				}
				
				it("should have the DELETE method") {
					let method: HTTPMethod = .delete
					expect(method.rawValue) == "DELETE"
				}
				
				it("should have the GET method") {
					let method: HTTPMethod = .get
					expect(method.rawValue) == "GET"
				}
				
				it("should have the HEAD method") {
					let method: HTTPMethod = .head
					expect(method.rawValue) == "HEAD"
				}
				
				it("should have the OPTIONS method") {
					let method: HTTPMethod = .options
					expect(method.rawValue) == "OPTIONS"
				}
				
				it("should have the PATCH method") {
					let method: HTTPMethod = .patch
					expect(method.rawValue) == "PATCH"
				}
				
				it("should have the POST method") {
					let method: HTTPMethod = .post
					expect(method.rawValue) == "POST"
				}
				
				it("should have the PUT method") {
					let method: HTTPMethod = .put
					expect(method.rawValue) == "PUT"
				}
				
				it("should have the TRACE method") {
					let method: HTTPMethod = .trace
					expect(method.rawValue) == "TRACE"
				}
			}
		}
	}
}
