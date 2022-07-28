//
//  Common.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/27.
//

import UIKit

//MARK: - 屏幕宽高
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let SCREEN_WIDTH = UIScreen.main.bounds.width

let TOP_SPACE = 5.0
let CENTER_TEM_FONT_SIZE = 60.0
let DETAIL_TITLE_CELL_FONT_SIZE = 15.0
let DETAIL_CONTENT_CELL_FONT_SIZE = 30.0
let WEATHER_CELL_FONT_SIZE = 10.0
let SELECT_CELL_FONT_SIZE = 15.0
//MARK: - cell identifier
let WEATHER_TABLEVIEWCELL_IDENTIFIER = "weatherCell"
let DETAIL_TABLEVIEWCELL_IDENTIFIER = "detailCell"
let SELECT_TABLEVIEWCELL_IDENTIFIER = "selectCell"

//MARK: - overall 内容处理
let weekDays = ["周六", "周日", "周一", "周二", "周三", "周四", "周五"]
func getWeekDays(days: [WeekDayWeather]) -> [String] {
    var ret = [String]()
    for idx in 0...(days.count - 1) {
        let date = days[idx].date!
        let d = date.split(separator: "-")[2]
        var nd: String = d + "号("
        if (idx == 0) {
            nd = nd + "今天)"
            ret.append(nd)
        } else if (idx == 1) {
            nd = nd + "明天)"
            ret.append(nd)
        } else if (idx == 2) {
            nd = nd + "后天)"
            ret.append(nd)
        } else {
            let wd = Date.getWeekDay(dateString: date) % 7
            nd = nd + weekDays[wd] + ")"
            ret.append(nd)
        }
    }
    return ret
}


func getDayWeatherMap(day: DayWeather) -> Dictionary<String, String> {
    var dict = Dictionary<String, String>()
    dict["temDay"] = day.temDay
    dict["temNight"] = day.temNight
    dict["win"] = day.win
    dict["winSpeed"] = day.winSpeed
    dict["winMeter"] = day.winMeter
    dict["air"] = day.air
    dict["pressure"] = day.pressure
    dict["humidity"] = day.humidity
    return dict
}

class Weather {
    static var city = ""
}

