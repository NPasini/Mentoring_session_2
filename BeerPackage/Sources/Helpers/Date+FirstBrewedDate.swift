//
//  Date+FirstBrewedDate.swift
//  
//
//  Created by Nicolò Pasini on 25/08/22.
//

import Foundation

extension Date {

    private static var brewDateSlashFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter
    }

    private static var brewDateDashFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-yyyy"
        formatter.timeZone = TimeZone(identifier: "GMT")
        return formatter
    }

    public static func firstBrewedDateFromString(_ stringDate: String) -> Date? {
        brewDateSlashFormatter.date(from: stringDate)
    }

    public static func prettyPrintFirstBrewedDate(_ date: Date) -> (dateFormat: Date, stringFormat: String) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "GMT")!
        let comps = calendar.dateComponents([.month, .year], from: date)
        let prettyPrintedDate = calendar.date(from: comps)!

        let stringValue = Date.brewDateSlashFormatter.string(from: date)

        return (prettyPrintedDate, stringValue)
    }

    public static func printFirstBrewedDateSeparatedByDash(_ date: Date) -> String {
        Date.brewDateDashFormatter.string(from: date)
    }
}
