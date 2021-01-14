//  Created by TCode on 10/01/2021.

import Foundation

public enum Question<T: Hashable> : Hashable {
    case singleAnswer(T)
    case multipleAnswer(T)

    // hasValue is deprecated
//    var hashValue: Int {
//        switch self {
//        case .singleAnswer(let a): return a.hashValue
//        case .multipleAnswer(let a): return a.hashValue
//        }
//    }

    public func hash(into hasher: inout Hasher) -> Int {
        switch self {
        case .singleAnswer(let a): return a.hashValue
        case .multipleAnswer(let a): return a.hashValue
        }
    }

    public static func ==(lhs: Question<T>, rhs: Question<T>) -> Bool {
        switch (lhs, rhs) {
        case (.singleAnswer(let a), singleAnswer(let b)): return a == b
        case (.multipleAnswer(let a), multipleAnswer(let b)): return a == b
        default: return false
        }
    }
}
