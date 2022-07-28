//
//  WeatherTableViewCell.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/27.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
        
    }
    //MARK: - UI
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "27(今天)"
        label.textColor = .gray
        label.font = .systemFont(ofSize: WEATHER_CELL_FONT_SIZE)
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
        label.font = .systemFont(ofSize: WEATHER_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var winSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "4-5级转<3级"
        label.textColor = .gray
        label.font = .systemFont(ofSize: WEATHER_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    lazy var temLabel: UILabel = {
        let label = UILabel()
        label.text = "30  10"
        label.textColor = .gray
        label.font = .systemFont(ofSize: WEATHER_CELL_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
}

extension WeatherTableViewCell {
    func setupUI() {
        self.addSubview(self.dateLabel)
        self.addSubview(self.temLabel)
        self.addSubview(self.winLabel)
        self.addSubview(self.weaImageView)
        self.addSubview(self.winSpeedLabel)
        prepareDateLabel()
        prepareTemLabel()
        prepareWinLabel()
        prepareWeaImageView()
        prepareWinSpeedLabel()
    }
    func prepareWinSpeedLabel() {
        self.winSpeedLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.dateLabel.snp.centerY)
            make.height.equalTo(self.dateLabel.snp.height)
            make.left.equalTo(self.snp.centerX).offset(self.bounds.width * 0.2)
        }
    }
    func prepareWeaImageView() {
        self.weaImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self.dateLabel.snp.centerY)
            make.height.equalTo(self.dateLabel.snp.height).multipliedBy(0.8)
            make.right.equalTo(self.snp.centerX).offset(-self.bounds.width * 0.16)
            make.width.equalTo(self.dateLabel.snp.height).multipliedBy(0.8)
        }
    }
    func prepareWinLabel() {
        self.winLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.dateLabel.snp.centerY)
            make.centerX.equalToSuperview()
            make.height.equalTo(self.dateLabel.snp.height)
        }
    }
    func prepareTemLabel() {
        self.temLabel.snp.makeConstraints { make in
            make.height.equalTo(self.dateLabel.snp.height)
            make.right.equalToSuperview()
            make.centerY.equalTo(self.dateLabel.snp.centerY)
        }
    }
    func prepareDateLabel() {
        self.dateLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.9)
            make.left.equalToSuperview().offset(TOP_SPACE)
            make.centerY.equalToSuperview()
        }
    }
}
