//  Created by TCode on 10/01/2021.

import Foundation
import XCTest
@testable import QEngine

class QuestionTests: XCTestCase {

    // SUT = System Under Test
    func test_hashValue_singleAnswer_returnsTypeHash() {
        let type = "a type"
        let sut = Question.singleAnswer(type)

        var hasher = Hasher()
        XCTAssertEqual(sut.hash(into: &hasher), type.hashValue)
    }

    func test_hashValue_multipleAnswer_returnsTypeHash() {
        let type = "a type"
        let sut = Question.multipleAnswer(type)

        var hasher = Hasher()
        XCTAssertEqual(sut.hash(into: &hasher), type.hashValue)
    }

    func test_equal_isEqual() {
        XCTAssertEqual(Question.singleAnswer("type"), Question.singleAnswer("type"))
        XCTAssertEqual(Question.multipleAnswer("type"), Question.multipleAnswer("type"))
    }

    func test_notEqual_isNotEqual() {
        XCTAssertNotEqual(Question.singleAnswer("type"), Question.singleAnswer("another type"))
        XCTAssertNotEqual(Question.multipleAnswer("type"), Question.multipleAnswer("another type"))
        XCTAssertNotEqual(Question.singleAnswer("type"), Question.multipleAnswer("type"))
    }
}
