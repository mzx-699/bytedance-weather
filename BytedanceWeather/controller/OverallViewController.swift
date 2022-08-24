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
class OverallViewController: BaseViewController {

    var netManager = NetManager()
    //MARK: - model
    var dayWeatherModel: DayWeather? = DayWeather.fromCache(key: Weather.city + "-" + DAYWEATHER_CACHE_KEY, cacheContainer: .hybrid)
    var weekWeatherModel: WeekWeather? = WeekWeather.fromCache(key: Weather.city + "-" + WEEKWEATHER_CACHE_KEY, cacheContainer: .hybrid)
    var weekdays: [String] = ["01号(今天)", "02号(明天)", "03号(后天)", "04号(周一)", "05号(周三)", "06号(周四)", "07号(周五)"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initNetDelegate()
        request()
        self.navigationItem.title = Weather.city
        self.weekdays = getWeekDays(days: self.weekWeatherModel?.data ?? nil)
        NotificationCenter.default.addObserver(forName: .init(rawValue: NOTIFICATION_CENTER_UPDATE_CITY), object: nil, queue: nil) { [weak self] _ in
            guard let self = self else {return}
            self.request()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = Weather.city
        super.viewWillAppear(animated)
    }
    //MARK: - 父类
    override func request() {
        self.netManager.dayWeatherRequest(city: Weather.city)
        self.netManager.weekWeatherRequest(city: Weather.city)
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
        tv.tableFooterView = UIView()
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
    private lazy var navRightUpdateBtn: WeatherNavButton = {
        let btn = WeatherNavButton()
        btn.multiple = 0.75
        btn.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: "current"), for: .normal)
        btn.addTarget(self, action: #selector(rightUpdateBtnClick), for: .touchUpInside)
        return btn
    }()
}

//MARK: - tableview delegate & datasouce
extension OverallViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.weekWeatherModel?.data?.count ?? 7) + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return UITableViewCell()
        }
        let day = self.weekWeatherModel?.data?[indexPath.section - 1]
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
extension OverallViewController: WeaetherDelegate {
    func initNetDelegate() {
        self.netManager.weatherDelegate = self
    }
    func acquireDayWeather(model: DayWeather) {
        self.dayWeatherModel = model
        updateDayWeatherData()
    }
    func acquireWeekWeather(model: WeekWeather) {
        self.weekWeatherModel = model
        updateWeekWeatherData()
    }
    // 获得请求数据后，需要更新
    func updateDayWeatherData() {
        self.dayWeatherModel?.cache(key: Weather.city + "-" + DAYWEATHER_CACHE_KEY, cacheContainer: .hybrid)
        DispatchQueue.main.async {
            self.temLabel.text = self.dayWeatherModel!.tem! + "℃"
            let temDay = self.dayWeatherModel!.temDay!
            let temNight = self.dayWeatherModel!.temNight!
            self.centerTemLabel.text = "最高温度: " + temDay + "℃ 最低温度: " + temNight + "℃"
            self.weaLabel.text = self.dayWeatherModel!.wea!
        }
    }
    func updateWeekWeatherData() {
        self.weekWeatherModel?.cache(key: Weather.city + "-" + WEEKWEATHER_CACHE_KEY, cacheContainer: .hybrid)
        DispatchQueue.main.async {
            self.weekdays = getWeekDays(days: (self.weekWeatherModel?.data)!)
            self.forecastTableView.reloadData()
        }
        
    }
    
}

//MARK: - btn
private extension OverallViewController {
    @objc func rightSelectBtnClick() {
        let vc = SelectCityViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func rightUpdateBtnClick() {
        endTimer()
        WeatherLocation.shareInstance.getLocationInfo = { [weak self] _, _, _city, _ in
            guard let self = self else {return}
            if let currCity = _city {
                // 截取掉市
                let l = currCity.count
                let start = currCity.startIndex
                let end = currCity.index(start, offsetBy: l - 1)
                let subCity = String(currCity[start..<end])
                // 弹框是否要更新到所在城市
                let alertController = UIAlertController(title: "定位到你所在的城市", message: "当前所在城市为: "+subCity, preferredStyle: .alert)
                let done = UIAlertAction(title: "确认", style: .default) { _ in
                    // 修改city相关
                    let oldCity = self.dayWeatherModel!.city!
                    var citys: [String] = UserDefaults.standard.array(forKey: "citys") as? [String] ?? []
                    // old 不在集合里，就放进去
                    if citys.firstIndex(of: oldCity) == nil {
                        citys.append(oldCity)
                    }
                    // new 在集合里就删掉
                    if let idx = citys.firstIndex(of: subCity) {
                        citys.remove(at: idx)
                    }
                    UserDefaults.standard.set(subCity, forKey: "city")
                    UserDefaults.standard.set(citys, forKey: "citys")
                    // 更新全局city
                    Weather.city = subCity
                    self.navigationItem.title = Weather.city
                    UserDefaults.standard.synchronize()
                    NotificationCenter.default.post(name: .init(rawValue: NOTIFICATION_CENTER_UPDATE_CITY), object: nil)
                    self.startTimer()
                }
                let cancel = UIAlertAction(title: "取消", style: .cancel) { _ in
                    self.startTimer()
                }
                alertController.addAction(done)
                alertController.addAction(cancel)
                self.present(alertController, animated: false, completion: nil)
            }
            
        }
        WeatherLocation.shareInstance.startLoaction()
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
        self.navigationItem.title = Weather.city
        let height = navigationController?.navigationBar.frame.size.height ?? 44.0
        self.navRightSelectBtn.frame = CGRect(x: 0, y: 0, width: height, height: height)
        let vSelect = UIView(frame: self.navRightSelectBtn.frame)
        vSelect.addSubview(self.navRightSelectBtn)
        self.navRightUpdateBtn.frame = CGRect(x: 0, y: 0, width: height, height: height)
        let vUpdate = UIView(frame: self.navRightUpdateBtn.frame)
        vUpdate.addSubview(self.navRightUpdateBtn)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: vSelect), UIBarButtonItem(customView: vUpdate)]
    }
}

