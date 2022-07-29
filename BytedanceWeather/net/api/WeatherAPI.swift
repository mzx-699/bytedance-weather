//
//  WeatherAPI.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/26.
//

import Foundation
import Moya

let WEATHER_APPID = "42679832"
let WEATHER_APPSECRET = "XaqZ7ZKt"

enum WeatherAPI: Equatable {
    
    case weekWeatherCity(_ city: String)
    case dayWeatherCity(_ city: String)
    case weekWeather
    case dayWeather
    
}

extension WeatherAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: WEATHER_URL)!
    }
    
    var method: Moya.Method {
        switch self {
        case .weekWeatherCity(_), .weekWeather:
            return .get
        case .dayWeatherCity(_), .dayWeather:
            return .get
        }
    }
    
    var task: Task {
        var parmeters: [String:Any] = ["appid": WEATHER_APPID, "appsecret" : WEATHER_APPSECRET, "unescape" : 1]
        switch self {
        case .weekWeatherCity(let city), .dayWeatherCity(let city):
            parmeters["city"] = city
        default: break
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var path: String {
        switch self {
        case .weekWeatherCity(_), .weekWeather:
            return "free/week"
        case .dayWeatherCity(_), .dayWeather:
            return "free/day"
        }
    }
}
