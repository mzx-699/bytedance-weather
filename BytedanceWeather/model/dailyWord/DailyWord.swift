//
//  DailyWordModel.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/27.
//

import Foundation
import SwiftyJSON
import MoyaMapper
struct DailyWord: Modelable {
//    init(json: JSON) {
//        content = json[0]["content"].stringValue
//        author = json[0]["author"].stringValue
//    }
    init() {
        
    }
    
    func mapping(_ json: JSON) {
        
    }
    var content: String?
    var author: String?

}
