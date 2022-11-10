//
//  Date+Helpers.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 30/08/22.
//

import Foundation

extension Date {

    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }

    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .day, value: days, to: self)!
    }

    func adding(years: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        return calendar.date(byAdding: .year, value: years, to: self)!
    }
}
