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

private func scoring<Question: Hashable, Answer: Equatable>(_ answers: [Question: Answer], correctAnswers: [Question: Answer]) -> Int  {
    return answers.reduce(0) { (score, tuple) in

        // Here is a VERY good example why using protocols where they are not necessary over concrete types might lead to other complications.
        // Arrays are Equatable since Swift 4.2 BUT the order does matter, which we don't want or multiple answer questions.
        // Therefore I have to use a Set instead of an Array for Answer type.
        // Trying to cast something to an array of Generics DOEN'T work, otherwise I would've had [T: Decodable] below.

        let  newPoints = correctAnswers[tuple.key] == tuple.value ? 1 : 0
        return score + newPoints
    }
}
