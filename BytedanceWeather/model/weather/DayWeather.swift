//
//  DayWeather.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/26.
//

import Foundation
import SwiftyJSON
import MoyaMapper

struct DayWeather: Modelable {
    init() {
        
    }
    
    mutating func mapping(_ json: JSON) {
        self.weaImg = json["wea_img"].stringValue
        self.updateTime = json["update_time"].stringValue
        self.temDay = json["tem_day"].stringValue
        self.temNight = json["tem_night"].stringValue
        self.winSpeed = json["win_speed"].stringValue
        self.winMeter = json["win_meter"].stringValue
    }

    
    var nums: Int?
    var cityid: String?
    var city: String?
    var date: String?
    var week: String?
    var updateTime: String?
    var wea: String?
    var weaImg: String?
    var tem: String?
    var temDay: String?
    var temNight: String?
    var win: String?
    var winSpeed: String?
    var winMeter: String?
    var air: String?
    var pressure: String?
    var humidity: String?
    
}
