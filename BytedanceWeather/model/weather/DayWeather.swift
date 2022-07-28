//
//  DayWeather.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/26.
//

import Foundation
import SwiftyJSON

class DayWeather: NSObject {

    init(json: JSON) {
        nums = json["nums"].intValue
        cityid = json["cityid"].stringValue
        city = json["city"].stringValue
        date = json["date"].stringValue
        week = json["week"].stringValue
        updateTime = json["update_time"].stringValue
        wea = json["wea"].stringValue
        weaImg = json["wea_img"].stringValue
        tem = json["tem"].stringValue
        temDay = json["tem_day"].stringValue
        temNight = json["tem_night"].stringValue
        win = json["win"].stringValue
        winSpeed = json["win_speed"].stringValue
        winMeter = json["win_meter"].stringValue
        air = json["air"].stringValue
        pressure = json["pressure"].stringValue
        humidity = json["humidity"].stringValue
    }
    
    @objc var nums: Int
    @objc var cityid: String?
    @objc var city: String?
    @objc var date: String?
    @objc var week: String?
    @objc var updateTime: String?
    @objc var wea: String?
    @objc var weaImg: String?
    @objc var tem: String?
    @objc var temDay: String?
    @objc var temNight: String?
    @objc var win: String?
    @objc var winSpeed: String?
    @objc var winMeter: String?
    @objc var air: String?
    @objc var pressure: String?
    @objc var humidity: String?
    
    override var description: String {
        let properties = ["nums", "cityid", "city", "date", "week", "updateTime", "wea", "weaImg", "tem", "temDay", "temNight", "win", "winSpeed", "winMeter", "air", "pressure", "humidity"]
        return dictionaryWithValues(forKeys: properties).description
     }
}
