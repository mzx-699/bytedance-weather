//
//  DailyWordModel.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/27.
//

import Foundation
import SwiftyJSON

class DailyWordModel: NSObject {
    init(json: JSON) {
        content = json[0]["content"].stringValue
        author = json[0]["author"].stringValue
    }
    
    @objc var content: String?
    @objc var author: String?
    
    override var description: String {
        let properties = ["content", "author"]
        return dictionaryWithValues(forKeys: properties).description
     }
}
