//
//  String+Ext.swift
//  GhFollowers
//
//  Created by Porori on 2/17/24.
//

import Foundation

extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = .current
        return dateFormatter.date(from: self)
    }
    
    // check for date from current String
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}
