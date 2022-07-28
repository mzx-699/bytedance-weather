//
//  Date+Extension.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/28.
//

import Foundation


extension Date {
    static func getWeekDay(dateString: String, formatterString: String = "yyyy-MM-dd") -> Int {
        
        let formatter = DateFormatter()
        formatter.dateFormat = formatterString
        let date = formatter.date(from: dateString)
        let calendar = Calendar(identifier: .gregorian)
        let comps = calendar.dateComponents([.weekday], from: date!)
        return comps.weekday ?? -1
    }
}
