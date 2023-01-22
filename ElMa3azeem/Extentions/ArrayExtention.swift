//
//  ArrayExtention.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 21/11/2022.
//

import Foundation

extension Array {
    init(repeating: [Element], count: Int) {
        self.init([[Element]](repeating: repeating, count: count).flatMap { $0 })
    }

    func repeated(_ count: Int) -> [Element] {
        return [Element](repeating: self, count: count)
    }

    mutating func remove(at indices: [Int]) {
        let rmIndices = Set(indices).sorted()
        var numRemoved: Int = 0
        for index in rmIndices {
            let indexToRemove = index - numRemoved
            remove(at: indexToRemove)
            numRemoved += 1
        }
    }

    mutating func mapInPlace(_ x: (inout Element) -> Void) {
        for i in indices {
            x(&self[i])
        }
    }
}

extension Array where Element: Encodable {
    func toString() -> String {
        do {
            let encodedData = try JSONEncoder().encode(self)
            let stringModel = String(data: encodedData, encoding: .utf8)
            return stringModel ?? "[]"
        } catch {
            return "[]"
        }
    }
}
