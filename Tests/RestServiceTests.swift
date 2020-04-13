import Quick
import Nimble
@testable import RestService

class RestServiceTests: QuickSpec {
	override func spec() {
		
		var service: RestService!
		
		describe("RestService") {
			
			beforeEach {
				service = RestService(host: "server.com")
			}
			
			context("initialization") {
				
				it("should have set the right default values") {
					expect(service.scheme) == .https
					expect(service.host) == "server.com"
					expect(service.port).to(beNil())
				}
				
				it("should set the given values") {
					service = RestService(scheme: .http, host: "server.com", port: 3000)
					expect(service.scheme) == .http
					expect(service.host) == "server.com"
					expect(service.port) == 3000
				}
			}
			
			context("buildQueryItems") {
				
				it("should create a string query item") {
					let parameters = Parameters(
						string: "something",
						int: nil,
						stringsList: nil,
						intList: nil
					)
					let queryItems = service.buildQueryItems(parameters: parameters)
					expect(queryItems.count) == 1
					expect(queryItems.first?.name) == "string"
					expect(queryItems.first?.value) == "something"
				}
				
				it("should create an int query item") {
					let parameters = Parameters(
						string: nil,
						int: 10,
						stringsList: nil,
						intList: nil
					)
					let queryItems = service.buildQueryItems(parameters: parameters)
					expect(queryItems.count) == 1
					expect(queryItems.first?.name) == "int"
					expect(queryItems.first?.value) == "10"
				}
				
				it("should create a string array query item") {
					let parameters = Parameters(
						string: nil,
						int: nil,
						stringsList: ["abc", "def"],
						intList: nil
					)
					let queryItems = service.buildQueryItems(parameters: parameters)
					expect(queryItems.count) == 2
					expect(queryItems.first?.name) == "stringsList"
					expect(queryItems.first?.value) == "abc"
					expect(queryItems.last?.name) == "stringsList"
					expect(queryItems.last?.value) == "def"
				}
				
				it("should create an int array query item") {
					let parameters = Parameters(
						string: nil,
						int: nil,
						stringsList: nil,
						intList: [15, 20]
					)
					let queryItems = service.buildQueryItems(parameters: parameters)
					expect(queryItems.count) == 2
					expect(queryItems.first?.name) == "intList"
					expect(queryItems.first?.value) == "15"
					expect(queryItems.last?.name) == "intList"
					expect(queryItems.last?.value) == "20"
				}
				
				it("should create a full list query items") {
					let parameters = Parameters(
						string: "something",
						int: 10,
						stringsList: ["abc", "def"],
						intList: [15, 20]
					)
					let queryItems = service.buildQueryItems(parameters: parameters)
					expect(queryItems.count) == 6
					let string = queryItems.filter { $0.name == "string" }.first?.value
					expect(string) == "something"
					let int = queryItems.filter { $0.name == "int" }.first?.value
					expect(int) == "10"
					let stringsList1 = queryItems.filter { $0.name == "stringsList" }.first?.value
					expect(stringsList1) == "abc"
					let stringsList2 = queryItems.filter { $0.name == "stringsList" }.last?.value
					expect(stringsList2) == "def"
					let intList1 = queryItems.filter { $0.name == "intList" }.first?.value
					expect(intList1) == "15"
					let intList2 = queryItems.filter { $0.name == "intList" }.last?.value
					expect(intList2) == "20"
				}
			}
			
			context("buildJsonBody") {
				
				it("should create a body with a string item") {
					let parameters = Parameters(
						string: "something",
						int: nil,
						stringsList: nil,
						intList: nil
					)
					let body = service.buildJsonBody(parameters: parameters)
					expect(body).toNot(beNil())
					let json = try? JSONSerialization.jsonObject(with: body!, options: .mutableContainers) as? [String: Any]
					expect(json).toNot(beNil())
					let string = json?["string"] as? String
					expect(string) == "something"
				}
				
				it("should create a body with an int item") {
					let parameters = Parameters(
						string: nil,
						int: 10,
						stringsList: nil,
						intList: nil
					)
					let body = service.buildJsonBody(parameters: parameters)
					expect(body).toNot(beNil())
					let json = try? JSONSerialization.jsonObject(with: body!, options: .mutableContainers) as? [String: Any]
					expect(json).toNot(beNil())
					let int = json?["int"] as? Int
					expect(int) == 10
				}
				
				it("should create a body with a string array item") {
					let parameters = Parameters(
						string: nil,
						int: nil,
						stringsList: ["abc", "def"],
						intList: nil
					)
					let body = service.buildJsonBody(parameters: parameters)
					expect(body).toNot(beNil())
					let json = try? JSONSerialization.jsonObject(with: body!, options: .mutableContainers) as? [String: Any]
					expect(json).toNot(beNil())
					let stringsList = json?["stringsList"] as? [String]
					expect(stringsList?.count) == 2
					expect(stringsList?.first) == "abc"
					expect(stringsList?.last) == "def"
				}
				
				it("should create a body with an int array item") {
					let parameters = Parameters(
						string: nil,
						int: nil,
						stringsList: nil,
						intList: [15, 20]
					)
					let body = service.buildJsonBody(parameters: parameters)
					expect(body).toNot(beNil())
					let json = try? JSONSerialization.jsonObject(with: body!, options: .mutableContainers) as? [String: Any]
					expect(json).toNot(beNil())
					let intList = json?["intList"] as? [Int]
					expect(intList?.count) == 2
					expect(intList?.first) == 15
					expect(intList?.last) == 20
				}
				
				it("should create a body with a full dictionary") {
					let parameters = Parameters(
						string: "something",
						int: 10,
						stringsList: ["abc", "def"],
						intList: [15, 20]
					)
					let body = service.buildJsonBody(parameters: parameters)
					expect(body).toNot(beNil())
					let json = try? JSONSerialization.jsonObject(with: body!, options: .mutableContainers) as? [String: Any]
					expect(json).toNot(beNil())
					let string = json?["string"] as? String
					expect(string) == "something"
					let int = json?["int"] as? Int
					expect(int) == 10
					let stringsList = json?["stringsList"] as? [String]
					expect(stringsList?.count) == 2
					expect(stringsList?.first) == "abc"
					expect(stringsList?.last) == "def"
					let intList = json?["intList"] as? [Int]
					expect(intList?.count) == 2
					expect(intList?.first) == 15
					expect(intList?.last) == 20
				}
			}
			
			context("jsonHeaders") {
				
				it("should have the right headers") {
					let headers = service.jsonHeaders()
					expect(headers["Content-Type"]) == "application/json"
				}
			}
			
			context("formDataHeaders") {
				
				it("should have the right headers") {
					let headers = service.formDataHeaders(boundary: "abcde")
					expect(headers["Content-Type"]) == "multipart/form-data; boundary=abcde"
				}
			}
		}
	}
}

// MARK: - Private helpers

private struct Parameters: Codable {
	let string: String?
	let int: Int?
	let stringsList: [String]?
	let intList: [Int]?
}
