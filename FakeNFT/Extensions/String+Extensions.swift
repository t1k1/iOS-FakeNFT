//
//  String+Extensions.swift
//  FakeNFT
//
//  Created by Admin on 12/10/23.
//

import Foundation

extension String {
    func dateFromISO8601String() -> Date {
        let isoDateFormatter = ISO8601DateFormatter()
        if let date = isoDateFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            return date
        }
        return isoDateFormatter.date(from: self) ?? Date()
    }
}
