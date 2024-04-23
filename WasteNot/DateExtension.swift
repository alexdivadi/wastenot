//
//  DateExtension.swift
//  WasteNot
//
//  Created by David Allen on 4/22/24.
//

import Foundation

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
