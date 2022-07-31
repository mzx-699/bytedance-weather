//
//  File.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/31.
//

import UIKit
import ESTabBarController_swift

class ESBasicContentView: ESTabBarItemContentView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 18, 150, 219
        textColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 18/255.0, green: 150/255.0, blue: 219/255.0, alpha: 1.0)
        iconColor = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(red: 18/255.0, green: 150/255.0, blue: 219/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
