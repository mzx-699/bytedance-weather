//
//  File.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/27.
//

import Foundation
import Moya

let DAILYWORD_APPID = "ripvwljtiqsn7yq8"
let DAILYWORD_APPSECRET = "Zy9pc3JNTDdBVGV0dVZ3c0ZhNkZkZz09"

enum DailyWordAPI {
    case recommend
}

extension DailyWordAPI: TargetType {

    var baseURL: URL {
        return URL(string: DAILYWORD_URL)!
    }
    
    var method: Moya.Method {
        switch self {
        case .recommend:
            return .get
        }
    }
    
    var task: Task {
        var parmeters: [String:Any] = ["app_id": DAILYWORD_APPID, "app_secret" : DAILYWORD_APPSECRET]
        switch self {
        case .recommend:
            parmeters["count"] = 1
        }
        return .requestParameters(parameters: parmeters, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var path: String {
        switch self {
        case .recommend:
            return "daily_word/recommend"
        }
    }
}
