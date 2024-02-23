//
//  Date+Ext.swift
//  GhFollowers
//
//  Created by Porori on 2/17/24.
//

import Foundation

extension Date {
    
//    func convertToMonthYearFormat() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM yyyy"
//        
//        return dateFormatter.string(from: self)
//    }

    func convertToMonthYearFormat() -> String {
        // default
        // return formatted(.dateTime)
        // return formatted(date: .long, time: .shortened)
        
        // custom
        return formatted(.dateTime.month().year())
    }
}
