//
//  DateExtension.swift
//  WasteNot
//
//  Created by David Allen on 4/22/24.
//

import Foundation
import UIKit

// From SO

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

extension Array where Element: Equatable, Element: Hashable {
    mutating func removeDuplicates() {
        let set = Set(self)
        self = Array(set)
    }
}

// From SO
extension Array where Element: Equatable
{
    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = self.firstIndex(of: element) { self.move(from: oldIndex, to: newIndex) }
    }
}
extension Array
{
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}

extension UIColor {
    static var greenButtonColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ?
                    UIColor(red: 42/255, green: 170/255, blue: 138/255, alpha: 1) :
                    UIColor(red: 53/255, green: 94/255, blue: 59/255, alpha: 1)
            }
        } else {
            return UIColor(red: 53/255, green: 94/255, blue: 59/255, alpha: 1)
        }
    }
}
