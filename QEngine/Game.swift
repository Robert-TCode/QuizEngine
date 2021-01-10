//  Created by TCode on 03/01/2021.

import Foundation

public class Game<Question, Answer: Equatable, R: Router> where R.Question == Question, R.Answer == Answer {
    let flow: Flow<Question, Answer, R>

    init(flow: Flow<Question, Answer, R>) {
        self.flow = flow
    }
}

public func startGame<Question, Answer: Equatable, R: Router>(
    questions: [Question],
    router: R,
    correctAnswers: [Question: Answer]) -> Game<Question, Answer, R>
                                        where R.Question == Question, R.Answer == Answer  {
    let flow = Flow(router: router, questions: questions) { scoring($0, correctAnswers: correctAnswers) }
    flow.start()
    return Game(flow: flow)
}

private func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int {
    return answers.reduce(0) { (score, tuple) in
        let newPoints = correctAnswers[tuple.key] == tuple.value ? 1 : 0
        return score + newPoints
    }
}
