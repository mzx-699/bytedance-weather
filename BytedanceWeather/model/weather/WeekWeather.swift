//
//  WeakWeather.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/26.
//

import Foundation
import SwiftyJSON
class WeekWeather: NSObject {
    init(json: JSON) {
        nums = json["nums"].intValue
        cityid = json["cityid"].stringValue
        city = json["city"].stringValue
        updateTime = json["update_time"].stringValue
        for (_, j):(String, JSON) in json["data"] {
            data.append(WeekDayWeather(json: j))
        }
        
    }
    @objc var nums: Int
    @objc var cityid: String?
    @objc var city: String?
    @objc var updateTime: String?
    @objc var data: [WeekDayWeather] = Array()
    
    override var description: String {
        let properties = ["nums", "cityid", "city", "updateTime", "data"]
        return dictionaryWithValues(forKeys: properties).description
     }

}
