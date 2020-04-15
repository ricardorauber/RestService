import Quick
import Nimble
@testable import RestService

class RestPathTests: QuickSpec {
	override func spec() {
		
		describe("RestPath") {
			
			context("equality") {
				
				it("same components should be true") {
					let restPath1: RestPath = .restPath1
					let restPath2: RestPath = .restPath1
					expect(restPath1 == restPath2).to(beTrue())
				}
				
				it("different components should be false") {
					let restPath1: RestPath = .restPath1
					let restPath2: RestPath = .restPath2
					expect(restPath1 == restPath2).to(beFalse())
				}
			}
			
			context("difference") {
				
				it("same components should be false") {
					let restPath1: RestPath = .restPath1
					let restPath2: RestPath = .restPath1
					expect(restPath1 != restPath2).to(beFalse())
				}
				
				it("different components should be true") {
					let restPath1: RestPath = .restPath1
					let restPath2: RestPath = .restPath2
					expect(restPath1 != restPath2).to(beTrue())
				}
			}
		}
	}
}

// MARK: - Private helpers

private extension RestPath {

	static let restPath1 = RestPath(rawValue: "restPath1")
	static let restPath2 = RestPath(rawValue: "restPath2")
}
