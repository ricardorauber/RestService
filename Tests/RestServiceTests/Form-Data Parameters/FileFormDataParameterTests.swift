import Foundation
import Quick
import Nimble
@testable import RestService

class FileFormDataParameterTests: QuickSpec {
	override func spec() {
		
		var parameter: FileFormDataParameter!
		
		describe("FileFormDataParameter") {
			
			context("formData") {
				
				it("should be nil with an empty name") {
					parameter = FileFormDataParameter(name: "", filename: "filename", contentType: "text/plain", data: Data())
					expect(parameter.formData(boundary: "boundary")).to(beNil())
				}
				
				it("should be nil with an empty filename") {
					parameter = FileFormDataParameter(name: "name", filename: "", contentType: "text/plain", data: Data())
					expect(parameter.formData(boundary: "boundary")).to(beNil())
				}
				
				it("should be nil with an empty contentType") {
					parameter = FileFormDataParameter(name: "name", filename: "filename", contentType: "", data: Data())
					expect(parameter.formData(boundary: "boundary")).to(beNil())
				}
				
				it("should be nil with an empty boundary") {
					parameter = FileFormDataParameter(name: "name", filename: "filename", contentType: "text/plain", data: Data())
					expect(parameter.formData(boundary: "")).to(beNil())
				}
				
				it("should have the right data") {
					let text = "some text".data(using: .utf8)!
					parameter = FileFormDataParameter(name: "name", filename: "filename", contentType: "text/plain", data: text)
					let result = parameter.formData(boundary: "boundary")
					expect(result).toNot(beNil())
					let string = String(data: result!, encoding: .utf8)
					expect(string).toNot(beNil())
					expect(string) == "--boundary\r\nContent-Disposition: form-data; name=\"name\"; filename=\"filename\"\r\nContent-Type: \"text/plain\"\r\n\r\nsome text\r\n"
				}
			}
		}
	}
}
