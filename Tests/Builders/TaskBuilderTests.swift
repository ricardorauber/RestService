import Foundation
import Quick
import Nimble
@testable import RestService

class TaskBuilderTests: QuickSpec {
    override func spec() {
        
        var builder: TaskBuilder!
        
        beforeEach {
            builder = TaskBuilder()
        }
        
        describe("TaskBuilder") {
            
            context("build") {
                
                it("should build a task without auto resume") {
                    let session = URLSession.shared
                    let url = URL(string: "https://google.com")!
                    let request = URLRequest(url: url)
                    let task = builder.build(
                        session: session,
                        request: request,
                        autoResume: false,
                        progress: nil,
                        completion: { _ in })
                    expect(task).toNot(beNil())
                    expect(task?.dataTask?.state) == .suspended
                }
                
                it("should build a task with auto resume") {
                    let session = URLSession.shared
                    let url = URL(string: "https://google.com")!
                    let request = URLRequest(url: url)
                    let task = builder.build(
                        session: session,
                        request: request,
                        autoResume: true,
                        progress: nil,
                        completion: { _ in })
                    expect(task).toNot(beNil())
                    expect(task?.dataTask?.state) == .running
                    task?.cancel()
                }
            }
        }
    }
}
