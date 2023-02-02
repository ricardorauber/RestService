import Quick
import Nimble
@testable import RestService

class HTTPSchemeTests: QuickSpec {
	override func spec() {
		
		describe("HTTPScheme") {
			
			context("equality") {
				
				it("same schemes should be true") {
					let scheme1: HTTPScheme = .http
					let scheme2: HTTPScheme = .http
					expect(scheme1 == scheme2).to(beTrue())
				}
				
				it("different schemes should be false") {
					let scheme1: HTTPScheme = .http
					let scheme2: HTTPScheme = .https
					expect(scheme1 == scheme2).to(beFalse())
				}
			}
			
			context("difference") {
				
				it("same schemes should be false") {
					let scheme1: HTTPScheme = .http
					let scheme2: HTTPScheme = .http
					expect(scheme1 != scheme2).to(beFalse())
				}
				
				it("different schemes should be true") {
					let scheme1: HTTPScheme = .http
					let scheme2: HTTPScheme = .https
					expect(scheme1 != scheme2).to(beTrue())
				}
			}
			
			context("default values") {
				
				it("should have the HTTP scheme") {
					let scheme: HTTPScheme = .http
					expect(scheme.rawValue) == "http"
				}
				
				it("should have the HTTPS scheme") {
					let scheme: HTTPScheme = .https
					expect(scheme.rawValue) == "https"
				}
			}
		}
	}
}
