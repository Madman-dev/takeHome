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
        
        // Date에서 바로 String으로 변환해줄 수 있는데 2 step을 선택하는 이유가 있는걸까? > Github's model provides date date as a String type.
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        // check for date from current String
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}
