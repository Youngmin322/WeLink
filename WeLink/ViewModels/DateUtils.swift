//
//  DateUtils.swift
//  WeLink
//
//  Created by weonyee on 8/7/25.
//

import Foundation

func formattedBirthDate(from dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")

    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "d MMM"
    outputFormatter.locale = Locale(identifier: "en_US")

    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    } else {
        return dateString
    }
}
