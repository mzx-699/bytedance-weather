//
//  DetailTableViewCell.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/28.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
    }
    lazy var leftTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textColor = .gray
        label.font = .systemFont(ofSize: DETAIL_TITLE_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var leftContentLabel: UILabel = {
        let label = UILabel()
        label.text = "content"
        label.textColor = .black
        label.font = .systemFont(ofSize: DETAIL_CONTENT_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var rightTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textColor = .gray
        label.font = .systemFont(ofSize: DETAIL_TITLE_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var rightContentLabel: UILabel = {
        let label = UILabel()
        label.text = "content"
        label.textColor = .black
        label.font = .systemFont(ofSize: DETAIL_CONTENT_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
}

extension DetailTableViewCell {
    func setupUI() {
        self.addSubview(self.leftTitleLabel)
        self.addSubview(self.leftContentLabel)
        self.addSubview(self.rightTitleLabel)
        self.addSubview(self.rightContentLabel)
        
        prepareLeftTitleLabel()
        prepareLeftContentLabel()
        prepareRightTitleLabel()
        prepareRightContentLabel()
    }
    
    func prepareLeftTitleLabel() {
        self.leftTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(TOP_SPACE)
            make.left.equalToSuperview().offset(TOP_SPACE)
            make.right.equalTo(self.snp.centerX)
            make.height.equalToSuperview().multipliedBy(0.25)
        }
    }
    func prepareLeftContentLabel() {
        self.leftContentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.leftTitleLabel.snp.bottom).offset(TOP_SPACE * 0.25)
            make.left.equalTo(self.leftTitleLabel.snp.left)
            make.right.equalTo(self.leftTitleLabel.snp.right)
        }
    }
    func prepareRightTitleLabel() {
        self.rightTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.leftTitleLabel.snp.centerY)
            make.height.equalTo(self.leftTitleLabel.snp.height)
            make.left.equalTo(self.snp.centerX).offset(TOP_SPACE)
            make.right.equalTo(self.snp.right)
        }
    }
    func prepareRightContentLabel() {
        self.rightContentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.leftContentLabel.snp.centerY)
            make.bottom.equalTo(self.leftContentLabel.snp.bottom)
            make.left.equalTo(self.rightTitleLabel.snp.left)
            make.right.equalTo(self.rightTitleLabel.snp.right)
        }
    }
    
    
}
