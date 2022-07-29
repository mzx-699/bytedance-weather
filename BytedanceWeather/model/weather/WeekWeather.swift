//
//  WeakWeather.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/26.
//

import Foundation
import SwiftyJSON
import MoyaMapper
struct WeekWeather: Modelable {
    init() {
        
    }
    
    mutating func mapping(_ json: JSON) {
        self.updateTime = json["update_time"].stringValue
    }
    
    var nums: Int?
    var cityid: String?
    var city: String?
    var updateTime: String?
    var data: [WeekDayWeather]?
    

}
