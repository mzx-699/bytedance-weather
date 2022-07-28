//
//  WeakDayWeather.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/26.
//

import Foundation
import SwiftyJSON
class WeekDayWeather: NSObject {
    init(json: JSON) {
        date = json["date"].stringValue
        wea = json["wea"].stringValue
        weaImg = json["wea_img"].stringValue
        temDay = json["tem_day"].stringValue
        temNight = json["tem_night"].stringValue
        win = json["win"].stringValue
        winSpeed = json["win_speed"].stringValue
    }
    
    @objc var date: String?
    @objc var wea: String?
    @objc var weaImg: String?
    @objc var temDay: String?
    @objc var temNight: String?
    @objc var win: String?
    @objc var winSpeed: String?
    
    override var description: String {
        let properties = ["date", "wea", "weaImg", "temDay", "temNight", "win", "winSpeed"]
        return dictionaryWithValues(forKeys: properties).description
     }
}
