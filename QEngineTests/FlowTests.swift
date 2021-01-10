//
//  FlowTests.swift
//  QuizGameTests
//
//  Created by TCode on 02/01/2021.
//

import Foundation
import XCTest

@testable import QEngine

class FlowTests: XCTestCase {

    let router = RouterSpy()

    func test_start_withNoQuestions_doesNotRouteToQuestion() {
        makeSUT(questions: []).start()

        XCTAssertTrue(router.routedQuestions.isEmpty)
    }

    func test_start_withOneQuestions_routeToQuestion() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertEqual(router.routedQuestions.count, 1)
    }

    func test_start_withOneQuestions_routedQuestion() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertEqual(router.routedQuestions.last, "Q1")
    }

    func test_startTwice_withTowQuestions_routesToFirstQuestionTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_routesToSecondAndThirdQuestion() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2", "Q3"])
    }

    func test_startAndAnswerFirstQuestion_doesNotRouteToAnotherQuestion() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        router.answerCallback("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }

    func test_start_withNoQuestions_routesToResults() {
        makeSUT(questions: []).start()

        XCTAssertEqual(router.routedResults!.answers, [:])
    }

    func test_start_withOneQuestions_doesNotRouteToResults() {
        makeSUT(questions: ["Q1"]).start()

        XCTAssertNil(router.routedResults)
    }

    func test_startsAndAnswerFirstAndSecond_withTwoQuestions_routesToResults() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedResults!.answers, ["Q1": "A1", "Q2": "A2"])
    }

    func test_startsAndAnswerFirst_withTwoQuestions_doesNotRoutesToResults() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        router.answerCallback("A1")

        XCTAssertNil(router.routedResults)
    }

    func test_startsAndAnswerFirstAndSecond_withTwoQuestions_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"]) { _ in 10 }
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedResults!.score, 10)
    }

    func test_startsAndAnswerFirstAndSecond_withTwoQuestions_scoresWithRightAnswers() {
        var receivedAnswers: [String: String] = [:]
        let sut = makeSUT(questions: ["Q1", "Q2"]) { answers in
            receivedAnswers = answers
            return 20
        }

        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(receivedAnswers, ["Q1": "A1", "Q2": "A2"])
    }

    // MARK: Helpers

    func makeSUT(questions: [String],
                 scoring: @escaping ([String: String]) -> Int = { _ in 0 })
                -> Flow<String, String, RouterSpy> {
        Flow(router: router, questions: questions, scoring: scoring)
    }

}
