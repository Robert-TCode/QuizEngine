//  Created by TCode on 02/01/2021.


// Control + Shift + Click = Multiple cursors <3

import Foundation

class Flow <Question, Answer, R: Router> where R.Question == Question, R.Answer == Answer {
    private let router: R
    private let questions: [Question]
    private var answers: [Question: Answer] = [:]
    private var scoring: ([Question: Answer]) -> Int

    init(router: R, questions: [Question], scoring: @escaping ([Question: Answer]) -> Int) {
        self.router = router
        self.questions = questions
        self.scoring = scoring
    }

    func start() {
        if let firstQuestion = questions.first {
            router.routeTo(question: firstQuestion,
                           answerCallback: nextCallback(from: firstQuestion))
        } else {
            router.routeTo(result: result())
        }
    }

    private func nextCallback(from currentQuestion: Question) -> (Answer) -> Void {
        { [weak self] in self?.routeNext(currentQuestion, $0) }
    }

    private func routeNext(_ question: Question, _ answer: Answer) {
        if let currentQuestionIndex = questions.firstIndex(of: question) {
            answers[question] = answer

            let nextQuestionIndex = currentQuestionIndex + 1
            if nextQuestionIndex < questions.count {
                let nextQuestion =  questions[nextQuestionIndex]
                router.routeTo(question: nextQuestion,
                               answerCallback: nextCallback(from: nextQuestion))
            } else {
                router.routeTo(result: result())
            }
        }
    }

    private func result() -> Result<Question, Answer> {
        return Result(answers: answers, score: scoring(answers))
    }
}
