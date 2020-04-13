import Quick
import Nimble
@testable import RestService

class TextFormDataParameterTests: QuickSpec {
	override func spec() {
		
		var parameter: TextFormDataParameter!
		
		describe("TextFormDataParameter") {
			
			context("formData") {
				
				it("should be nil with an empty name") {
					parameter = TextFormDataParameter(name: "", value: "value")
					expect(parameter.formData(boundary: "boundary")).to(beNil())
				}
				
				it("should be nil with an empty value") {
					parameter = TextFormDataParameter(name: "name", value: "")
					expect(parameter.formData(boundary: "boundary")).to(beNil())
				}
				
				it("should be nil with an empty boundary") {
					parameter = TextFormDataParameter(name: "", value: "")
					expect(parameter.formData(boundary: "")).to(beNil())
				}
				
				it("should have the right data") {
					parameter = TextFormDataParameter(name: "name", value: "value")
					let result = parameter.formData(boundary: "boundary")
					expect(result).toNot(beNil())
					let string = String(data: result!, encoding: .utf8)
					expect(string).toNot(beNil())
					expect(string) == "--boundary\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\nvalue\r\n"
				}
			}
		}
	}
}
