//  Created by TCode on 03/01/2021.

import Foundation

@testable import QEngine

class RouterSpy: Router {
    var routedQuestions: [String] = []
    var routedResults: Result<String, String>? = nil
    var answerCallback: ((Answer) -> Void) = { _ in }

    func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
        routedQuestions.append(question)
        self.answerCallback = answerCallback
    }

    func routeTo(result: Result<String, String>) {
        self.routedResults = result
    }
}
