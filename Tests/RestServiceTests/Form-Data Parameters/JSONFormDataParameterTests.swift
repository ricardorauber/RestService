import Foundation
import Quick
import Nimble
@testable import RestService

class JSONFormDataParameterTests: QuickSpec {
	override func spec() {
		
		var parameter: JSONFormDataParameter!
		
		describe("JSONFormDataParameter") {
			
			context("formData") {
				
				it("should be nil with an empty name") {
					parameter = JSONFormDataParameter(name: "", object: "value")
					expect(parameter.formData(boundary: "boundary")).to(beNil())
				}
				
				it("should be nil with an empty boundary") {
					parameter = JSONFormDataParameter(name: "", object: "")
					expect(parameter.formData(boundary: "")).to(beNil())
				}
				
				it("should have the right data") {
                    let person = Person(name: "Ricardo", age: 35)
					parameter = JSONFormDataParameter(name: "name", object: person)
					let result = parameter.formData(boundary: "boundary")
					expect(result).toNot(beNil())
					let string = String(data: result!, encoding: .utf8)
					expect(string).toNot(beNil())
					expect(string) == "--boundary\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\n{\"name\":\"Ricardo\",\"age\":35}\r\n"
				}
			}
		}
	}
}

// MARK: - Test Helpers
private struct Person: Codable {
    var name: String
    var age: Int
}
