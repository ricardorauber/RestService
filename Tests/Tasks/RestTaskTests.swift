import Foundation
import Quick
import Nimble
@testable import RestService

class RestTaskTests: QuickSpec {
    override func spec() {
        
        var task: RestTask!
        var request: URLRequest!
        
        beforeEach {
            task = RestTask()
            let url = URL(string: "https://www.google.com")!
            request = URLRequest(url: url)
        }
        
        describe("RestTask") {
            
            context("prepare") {
                
                it("should prepare the task correctly") {
                    var progressTicked = false
                    var completionTicked = false
                    task.prepare(
                        request: request,
                        progress: { _ in
                            progressTicked = true
                        },
                        completion: { _ in
                            completionTicked = true
                        }
                    )
                    task.resume()
                    expect(progressTicked).toEventually(beTrue())
                    expect(completionTicked).toEventually(beTrue())
                }
                
                it("should prepare the task without resuming it") {
                    task.prepare(
                        request: request,
                        progress: { _ in },
                        completion: { _ in })
                    expect(task.dataTask).toNot(beNil())
                    expect(task.dataTask?.state) == .suspended
                }
                
                it("should resume the dataTask when needed") {
                    task.prepare(
                        request: request,
                        progress: { _ in },
                        completion: { _ in })
                    expect(task.dataTask).toNot(beNil())
                    task.resume()
                    expect(task.dataTask?.state) == .running
                    task.cancel()
                }
                
                it("should suspend the dataTask when needed") {
                    task.prepare(
                        request: request,
                        progress: { _ in },
                        completion: { _ in })
                    expect(task.dataTask).toNot(beNil())
                    task.resume()
                    task.suspend()
                    expect(task.dataTask?.state) == .suspended
                }
            }
        }
    }
}
