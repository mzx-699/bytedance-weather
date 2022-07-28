//
//  DBButton.swift
//  SmartLawnMower
//
//  Created by 麻志翔 on 2021/12/15.
//

import UIKit

class WeatherNavButton: UIButton {
    
    var multiple: Double = 0.7
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let idxMultiple = (1 - multiple) * 0.5
        return CGRect(x: self.bounds.width * idxMultiple, y: self.bounds.height * idxMultiple, width: self.bounds.width * multiple, height: self.bounds.height * multiple)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
