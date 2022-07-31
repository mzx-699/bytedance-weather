//
//  NetManager.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/27.
//

import Foundation
import Moya
import SwiftyJSON

class NetManager: NSObject {
    
    weak var weatherDelegate : WeaetherDelegate?
    weak var dailyWordDelegate : DailyWordDelegate?
    let weatherProvider = MoyaProvider<WeatherAPI>()
    let dailyWordProvider = MoyaProvider<DailyWordAPI>()
    
    func weatherRequest(type: WeatherAPI) {
        let _ = weatherProvider.cacheRequest(type, cacheType: .default, callbackQueue: DispatchQueue.main, progress: nil) { result in
            switch result {
            case let .success(resp):
                let json = try! JSON(data: resp.data)
                if json.count < 5 {
                    break
                }
                if resp.statusCode == 200 {
                    switch type {
                    case .weekWeather, .weekWeatherCity(_):
                        let ww = resp.mapObject(WeekWeather.self, modelKey: nil)
                        self.weatherDelegate?.acquireWeekWeather(model: ww)
                    case .dayWeather, .dayWeatherCity(_):
                        let dw = resp.mapObject(DayWeather.self, modelKey: nil)
                        self.weatherDelegate?.acquireDayWeather(model: dw)
                    }
                } else if resp.statusCode == 230 {
                    switch type {
                    case .weekWeather, .weekWeatherCity(_):
                        let ww = resp.mapObject(WeekWeather.self, modelKey: nil)
                        self.weatherDelegate?.acquireWeekWeatherCache(model: ww)
                    case .dayWeather, .dayWeatherCity(_):
                        let dw = resp.mapObject(DayWeather.self, modelKey: nil)
                        self.weatherDelegate?.acquireDayWeatherCache(model: dw)
                    }
                }
            case let .failure(moyaError):
                delog(moyaError)
                break
            }
        }
    }
    
    func dailyWordRequest(type: DailyWordAPI) {
        let _ = dailyWordProvider.cacheRequest(type, cacheType: .default, callbackQueue: DispatchQueue.main, progress: nil) { result in
            switch result {
            case let .success(resp):
                if resp.statusCode == 200 {
                    let json = try! JSON(data: resp.data)
                    let dw = DailyWord.mapModel(from: json["data"][0])
                    self.dailyWordDelegate?.acquireDailyWord(model: dw)
                } else if resp.statusCode == 230 {
                    let json = try! JSON(data: resp.data)
                    let dw = DailyWord.mapModel(from: json["data"][0])
                    self.dailyWordDelegate?.acquireDailyWordCache(model: dw)
                }
            case let .failure(moyaError):
                print(moyaError)
            }
        }
    }
    
    func weekWeatherRequest(city: String) {
        if (city == "") {
            weatherRequest(type: .weekWeather)
        } else {
            weatherRequest(type: .weekWeatherCity(city))
        }
    }
    func dayWeatherRequest(city: String) {
        if (city == "") {
            weatherRequest(type: .dayWeather)
        } else {
            weatherRequest(type: .dayWeatherCity(city))
        }
    }
}
