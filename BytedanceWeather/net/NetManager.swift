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
        weatherProvider.request(type) { result in
            switch result {
            case let .success(resp):
                if resp.statusCode == 200 {
                    switch(type) {
                    case .weekWeather, .weekWeatherCity(_):
                        let ww = WeekWeather(json: JSON(resp.data))
                        self.weatherDelegate?.acquireWeekWeather(model: ww)
                    case .dayWeather, .dayWeatherCity(_):
                        let dw = DayWeather(json: JSON(resp.data))
                        self.weatherDelegate?.acquireDayWeather(model: dw)
                    }
                }
                break
            case let .failure(moyaError):
                print(moyaError)
                break
            }
        }
    }
    
    func dailyWordRequest(type: DailyWordAPI) {
        dailyWordProvider.request(type) { result in
            switch result {
            case let .success(resp):
                //TODO: - 代理方法展示
                let dw = DailyWordModel(json: JSON(resp.data)["data"])
                self.dailyWordDelegate?.acquireDailyWord(model: dw)
                break
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
