//
//  WeakDayWeather.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/26.
//

import Foundation
import SwiftyJSON
import MoyaMapper
struct WeekDayWeather: Modelable {
    init() {
        
    }
    
    mutating func mapping(_ json: JSON) {
        self.weaImg = json["wea_img"].stringValue
        self.temDay = json["tem_day"].stringValue
        self.temNight = json["tem_night"].stringValue
        self.winSpeed = json["win_speed"].stringValue
    }
    
    
    var date: String?
    var wea: String?
    var weaImg: String?
    var temDay: String?
    var temNight: String?
    var win: String?
    var winSpeed: String?
    
}
