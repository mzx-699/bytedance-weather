//
//  SelectTableViewCell.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/28.
//

import UIKit

class SelectTableViewCell: UITableViewCell {


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
    }
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: SELECT_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var weaImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "qing"))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    lazy var temLabel: UILabel = {
        let label = UILabel()
        label.text = "30  10"
        label.textColor = .gray
        label.font = .systemFont(ofSize: SELECT_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var winLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: SELECT_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var winSpeedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: SELECT_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
}
private extension SelectTableViewCell {
    func setupUI() {
        
    }
    
    //TODO: - 布局
}
