//
//  DailyWordDelegate.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/27.
//

import Foundation
protocol DailyWordDelegate: NSObjectProtocol {
    
    func acquireDailyWord(model: DailyWord)
    func acquireDailyWordCache(model: DailyWord)
    
}
