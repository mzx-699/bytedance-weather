//
//  WeatherAPIDelegate.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/27.
//

import Foundation


protocol WeaetherDelegate {
    
    func acquireWeekWeather(model: WeekWeather)
    func acquireDayWeather(model: DayWeather)
}
