//
//  DateFormatter.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 18.08.2024.
//

import Foundation

final class DateFormatter {
    static let shared = DateFormatter()
        private init() {
            dateFormatter.dateFormat = "d MMMM yyyy"
            dateFormatter.locale = Locale(identifier: "ru_RU")
        }
        private let dateFormatter = Foundation.DateFormatter()

        func formatUnixTimestamp(_ timestamp: TimeInterval) -> String {
            let date = Date(timeIntervalSince1970: timestamp)
            return dateFormatter.string(from: date)
        }
}
