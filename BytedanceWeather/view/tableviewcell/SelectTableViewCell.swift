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
    lazy var winLabel: UILabel = {
        let label = UILabel()
        label.text = "东北风"
        label.textColor = .gray
        label.font = .systemFont(ofSize: SELECT_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var winSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "4-5级转<3级"
        label.textColor = .gray
        label.font = .systemFont(ofSize: SELECT_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        label.contentMode = .center
        return label
    }()
    lazy var temLabel: UILabel = {
        let label = UILabel()
        label.text = "30  10"
        label.textColor = .gray
        label.font = .systemFont(ofSize: SELECT_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .right
        return label
    }()
    
}
private extension SelectTableViewCell {
    func setupUI() {
        self.addSubview(self.cityLabel)
        self.addSubview(self.temLabel)
        self.addSubview(self.winLabel)
        self.addSubview(self.weaImageView)
        self.addSubview(self.winSpeedLabel)
        prepareCityLabel()
        prepareTemLabel()
        prepareWinLabel()
        prepareWeaImageView()
        prepareWinSpeedLabel()
    }
    func prepareWinSpeedLabel() {
        self.winSpeedLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.cityLabel.snp.centerY)
            make.height.equalTo(self.cityLabel.snp.height)
            make.left.equalTo(self.snp.centerX).offset(self.bounds.width * 0.12)
            
        }
    }
    func prepareWeaImageView() {
        self.weaImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.cityLabel.snp.centerY)
            make.height.equalTo(self.cityLabel.snp.height).multipliedBy(0.7)
            make.right.equalTo(self.snp.centerX).offset(-self.bounds.width * 0.14)
            make.width.equalTo(self.cityLabel.snp.height).multipliedBy(0.7)
        }
    }
    func prepareWinLabel() {
        self.winLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.cityLabel.snp.centerY)
            make.centerX.equalToSuperview()
            make.height.equalTo(self.cityLabel.snp.height)
        }
    }
    func prepareTemLabel() {
        self.temLabel.snp.makeConstraints { make in
            make.height.equalTo(self.cityLabel.snp.height)
            make.right.equalToSuperview().offset(-TOP_SPACE)
            make.centerY.equalTo(self.cityLabel.snp.centerY)
            make.left.equalTo(self.winSpeedLabel.snp.right).offset(TOP_SPACE * 0.5)
            
        }
    }
    func prepareCityLabel() {
        self.cityLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.9)
            make.left.equalToSuperview().offset(TOP_SPACE)
            make.centerY.equalToSuperview()
        }
    }
}
