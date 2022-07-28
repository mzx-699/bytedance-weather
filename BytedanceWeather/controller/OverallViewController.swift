//
//  ViewController.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/25.
//

import UIKit
import Moya
import SwiftyJSON
import SnapKit
class OverallViewController: UIViewController {

    // 网络
    let netManager = NetManager()
    //MARK: - model
    var dayWeatherModel: DayWeather?
    var weekWeatherModel: WeekWeather?
    var dailyWordModel: DailyWordModel?
    var weekdays: [String] = ["01号(今天)", "02号(明天)", "03号(后天)", "04号(周一)", "05号(周三)", "06号(周四)", "07号(周五)"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initNetDelegate()
        self.netManager.weekWeatherRequest(city: Weather.city)
        self.netManager.dayWeatherRequest(city: Weather.city)
        
    }
    //MARK: - ui
    // 中间温度label
    private lazy var temLabel: UILabel = {
        let label = UILabel()
        label.text = "30℃"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: CENTER_TEM_FONT_SIZE)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    // 中间最高温度，最低温度 label
    private lazy var centerTemLabel: UILabel = {
        let label = UILabel()
        label.text = "最高温度: 30℃ 最低温度: 20℃"
        label.textColor = .gray
        label.alpha = 0.6
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    // 温度右下角添加
    private lazy var weaLabel: UILabel = {
        let label = UILabel()
        label.text = "晴"
        label.textColor = .gray
        label.alpha = 0.6
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    // 下面的七天预报
    private lazy var forecastTableView: UITableView = {
        let tv = UITableView();
        tv.delegate = self
        tv.dataSource = self
        tv.register(WeatherTableViewCell.self, forCellReuseIdentifier: WEATHER_TABLEVIEWCELL_IDENTIFIER)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.isScrollEnabled = false
        tv.separatorStyle = .singleLine
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return tv
    }()
    
    private lazy var navRightSelectBtn: WeatherNavButton = {
        let btn = WeatherNavButton()
        btn.multiple = 0.75
        btn.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: "city"), for: .normal)
        btn.addTarget(self, action: #selector(rightSelectBtnClick), for: .touchUpInside)
        return btn
    }()
    
}

//MARK: - tableview delegate & datasouce
extension OverallViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.weekWeatherModel?.data.count ?? 7) + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return UITableViewCell()
        }
        let day = self.weekWeatherModel?.data[indexPath.section - 1]
        let cell = tableView.dequeueReusableCell(withIdentifier: WEATHER_TABLEVIEWCELL_IDENTIFIER, for: indexPath) as! WeatherTableViewCell
        cell.selectionStyle = .none
        cell.dateLabel.text = self.weekdays[indexPath.section - 1]
        cell.weaImageView.image = UIImage(named: day?.weaImg ?? "qing")
        cell.winLabel.text = day?.win ?? "东北风"
        cell.winSpeedLabel.text = day?.winSpeed ?? "4-5级转<3级"
        cell.temLabel.text = (day?.temDay ?? "30") + "  " + (day?.temNight ?? "20")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 5
        }
        return SCREEN_HEIGHT * 0.75 * 0.1
    }
    
}

//MARK: - net delegate
extension OverallViewController: DailyWordDelegate, WeaetherDelegate {
    
    func initNetDelegate() {
        self.netManager.weatherDelegate = self
        self.netManager.dailyWordDelegate = self
    }
    func acquireDayWeather(model: DayWeather) {
        self.dayWeatherModel = model
        updateDayWeatherData()
    }
    func acquireWeekWeather(model: WeekWeather) {
        self.weekWeatherModel = model
        updateWeekWeatherData()
    }
    func acquireDailyWord(model: DailyWordModel) {
        self.dailyWordModel = model
    }
    // 获得请求数据后，需要更新
    func updateDayWeatherData() {
        self.navigationItem.title = self.dayWeatherModel!.city!
        self.temLabel.text = self.dayWeatherModel!.tem! + "℃"
        let temDay = self.dayWeatherModel!.temDay!
        let temNight = self.dayWeatherModel!.temNight!
        self.centerTemLabel.text = "最高温度: " + temDay + "℃ 最低温度: " + temNight + "℃"
        self.weaLabel.text = self.dayWeatherModel!.wea!
        // 开启延时任务
        DispatchQueue.global().asyncAfter(deadline: .now() + 60) {
            self.netManager.dayWeatherRequest(city: Weather.city)
        }
        
    }
    func updateWeekWeatherData() {
        self.weekdays = getWeekDays(days: (self.weekWeatherModel?.data)!)
        forecastTableView.reloadData()
        DispatchQueue.global().asyncAfter(deadline: .now() + 60) {
            self.netManager.weekWeatherRequest(city: Weather.city)
        }
    }
    
}

//MARK: - btn
private extension OverallViewController {
    @objc func rightSelectBtnClick() {
        let vc = SelectCityViewController()
        vc.city = self.dayWeatherModel?.city ?? "北京"
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - set UI
extension OverallViewController {
    func setupUI() {
        setupNav()
        self.view.addSubview(self.temLabel)
        self.view.addSubview(self.centerTemLabel)
        self.view.addSubview(self.weaLabel)
        self.view.addSubview(self.forecastTableView)
        prepareTemLabel()
        prepareCenterTemLabel()
        prepareWeaLabel()
        prepareForecastTableView()
    }
    func prepareForecastTableView() {
        self.forecastTableView.snp.makeConstraints { make in
            make.centerX.equalTo(self.temLabel.snp.centerX)
            make.top.equalTo(self.centerTemLabel.snp.bottom).offset(TOP_SPACE * 2)
            make.bottom.equalTo(self.view.snp.bottom).offset(-TOP_SPACE * 2)
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    func prepareTemLabel() {
        self.temLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(self.view.snp.width).multipliedBy(0.3)
            make.top.equalTo(self.view.snp.top).offset(self.view.bounds.width * 0.25)
        }
    }
    func prepareCenterTemLabel() {
        self.centerTemLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.temLabel.snp.centerX)
            make.width.equalToSuperview()
            make.top.equalTo(self.temLabel.snp.bottom).offset(TOP_SPACE)
        }
    }
    func prepareWeaLabel() {
        self.weaLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.temLabel.snp.bottom)
            make.right.equalToSuperview()
            make.left.equalTo(self.temLabel.snp.right).offset(TOP_SPACE * 0.5)
        }
    }
    func setupNav() {
        
        self.navigationItem.title = self.dayWeatherModel?.city ?? "北京"
        let height = navigationController?.navigationBar.frame.size.height ?? 44.0
        self.navRightSelectBtn.frame = CGRect(x: 0, y: 0, width: height, height: height)
        let v = UIView(frame: self.navRightSelectBtn.frame)
        v.addSubview(self.navRightSelectBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: v)
        
    }
}

