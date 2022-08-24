//
//  SelectCityViewController.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/28.
//

import UIKit
import Toast_Swift
import SwiftyJSON
import Moya
class SelectCityViewController: BaseViewController {
    
    var netManager = NetManager()
    var flag = false
    private var currentCityModel: DayWeather?
    private var citysModelMap: [Int : DayWeather] = [:]
    private var selectCitys: [String] = {
        return UserDefaults.standard.array(forKey: "citys") as? [String] ?? []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        readCache()
        setupUI()
        initNetDelegate()
        request()
    }
    //MARK: - 父类
    override func request() {
        self.netManager.dayWeatherRequest(city: Weather.city)
        self.selectCitys.forEach { c in
            self.netManager.dayWeatherRequest(city: c)
        }
    }
    //MARK: - ui
    private lazy var currentCityLabel: UILabel = {
        let label = UILabel()
        label.text = "当前城市"
        label.textColor = .black
        label.font = .systemFont(ofSize: 30.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var citysLabel: UILabel = {
        let label = UILabel()
        label.text = "你的城市群"
        label.textColor = .black
        label.font = .systemFont(ofSize: 30.0)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    private lazy var currentTableView: UITableView = {
        let tv = UITableView();
        tv.delegate = self
        tv.dataSource = self
        tv.register(SelectTableViewCell.self, forCellReuseIdentifier: SELECT_TABLEVIEWCELL_IDENTIFIER)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.isScrollEnabled = false;
        tv.tag = 1
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return tv
    }()
    private lazy var citysTableView: UITableView = {
        let tv = UITableView();
        tv.delegate = self
        tv.dataSource = self
        tv.register(SelectTableViewCell.self, forCellReuseIdentifier: SELECT_TABLEVIEWCELL_IDENTIFIER)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .singleLine
        tv.isScrollEnabled = false;
        tv.tag = 2
        tv.bounces = false
        tv.tableFooterView = UIView()
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return tv
    }()
    private lazy var addBtn: WeatherNavButton = {
        let btn = WeatherNavButton()
        btn.multiple = 0.8
        btn.setImage(UIImage(named: "add"), for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.backgroundColor = UIColor(red: 77 / 255, green: 194 / 255, blue: 255 / 255, alpha: 1)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        return btn
    }()
    private lazy var changeBtn: WeatherNavButton = {
        let btn = WeatherNavButton()
        btn.multiple = 0.8
        btn.adjustsImageWhenHighlighted = false
        btn.setImage(UIImage(named: "change"), for: .normal)
        btn.backgroundColor = UIColor(red: 77 / 255, green: 194 / 255, blue: 255 / 255, alpha: 1)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(changeBtnClick), for: .touchUpInside)
        return btn
    }()
    private lazy var navBackBtn: WeatherNavButton = {
        let btn = WeatherNavButton()
        btn.multiple = 0.75
        btn.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: "back"), for: .normal)
        btn.addTarget(self, action: #selector(navBackBtnClick), for: .touchUpInside)
        return btn
    }()
    
}
//MARK: - net delegate
extension SelectCityViewController: WeaetherDelegate {
    func readCache() {
        self.currentCityModel = DayWeather.fromCache(key: Weather.city + "-" + DAYWEATHER_CACHE_KEY, cacheContainer: .hybrid)
        for idx in 0..<self.selectCitys.count {
            self.citysModelMap[idx] = DayWeather.fromCache(key: self.selectCitys[idx] + "-" + DAYWEATHER_CACHE_KEY, cacheContainer: .hybrid)
        }
    }
    func initNetDelegate() {
        self.netManager.weatherDelegate = self
    }
    func acquireWeekWeather(model: WeekWeather) {}
    
    func acquireDayWeather(model: DayWeather) {
        updateDayWeatherModel(model: model)
    }
    func updateDayWeatherModel(model: DayWeather) {
        DispatchQueue.main.async {
            if (model.city == Weather.city) {
                self.currentCityModel = model
                self.currentCityModel?.cache(key: Weather.city + "-" + DAYWEATHER_CACHE_KEY, cacheContainer: .hybrid)
                self.currentTableView.reloadData()
            } else {
                let idx = self.selectCitys.firstIndex(of: model.city!)!
                self.citysModelMap[idx] = model
                model.cache(key: model.city! + "-" + DAYWEATHER_CACHE_KEY, cacheContainer: .hybrid)
                self.citysTableView.reloadData()
                // 只有添加的时候才能滚动
                if (self.citysTableView.isScrollEnabled && self.flag) {
                    self.flag = false
                    let indexPath = NSIndexPath(row: self.selectCitys.count - 1, section: 0) as IndexPath
                    self.citysTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    
}
//MARK: - tableview delegate & datasouce
extension SelectCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return 1
        } else if tableView.tag == 2 {
            if CGFloat(self.selectCitys.count) * SCREEN_HEIGHT * 0.075 > tableView.frame.height {
                tableView.isScrollEnabled = true
            } else {
                tableView.isScrollEnabled = false
            }
            return self.selectCitys.count
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SELECT_TABLEVIEWCELL_IDENTIFIER, for: indexPath) as! SelectTableViewCell
        if (tableView.tag == 1) {
            let current = self.currentCityModel
            cell.cityLabel.text = current?.city ?? Weather.city
            cell.weaImageView.image = UIImage(named: current?.weaImg ?? "qing")
            cell.winLabel.text = current?.win ?? "东北风"
            cell.winSpeedLabel.text = current?.winSpeed ?? "4-5级转<3级"
            cell.temLabel.text = (current?.temDay ?? "30") + "  " + (current?.temNight ?? "20")
            cell.selectionStyle = .none
        } else if tableView.tag == 2 {
            let city = self.citysModelMap[indexPath.row]
            cell.cityLabel.text = self.selectCitys[indexPath.row]
            cell.weaImageView.image = UIImage(named: city?.weaImg ?? "qing")
            cell.winLabel.text = city?.win ?? "东北风"
            cell.winSpeedLabel.text = city?.winSpeed ?? "4-5级转<3级"
            cell.temLabel.text = (city?.temDay ?? "30") + "  " + (city?.temNight ?? "20")
            cell.selectionStyle = .default
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPress(sender:)))
            longPressGesture.minimumPressDuration = 1.0
            cell.addGestureRecognizer(longPressGesture)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SelectTableViewCell
        cell.isSelected = false
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCREEN_HEIGHT * 0.075
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView.tag == 2 {
            return true
        }
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let idx = indexPath.row
            self.selectCitys.remove(at: idx)
            UserDefaults.standard.set(self.selectCitys, forKey: "citys")
            UserDefaults.standard.synchronize()
            tableView.reloadData()
        }
    }
    // 长按cell
    @objc private func cellLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            // 关闭定时器
            endTimer()
            let point = sender.location(in: self.citysTableView)
            let path = self.citysTableView.indexPathForRow(at: point)!
            let cell = self.citysTableView.cellForRow(at: path) as! SelectTableViewCell
            let alertController = UIAlertController(title: "选择该城市作为你的城市", message: nil, preferredStyle: .alert)
            let done = UIAlertAction(title: "确认", style: .default) { [weak self] alertAction in
                guard let self = self else {return}
                let changeCity = cell.cityLabel.text
                self.doChangeCity(changeCity: changeCity!)
                // 重启定时器
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
    
    
}
//MARK: - btn click
private extension SelectCityViewController {
    //TODO: - 接口bug 传安徽 返回北京
    @objc func changeBtnClick() {
        delog("\(#function)")
        endTimer()
        let alertController = UIAlertController(title: "请输入当前所在城市", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { [weak self] alertAction in
            guard let self = self else {return}
            let changeCity = alertController.textFields?[0].text ?? ""
            if changeCity == "" {
                // 重启定时器
                self.startTimer()
                return
            }
            self.netManager.weatherProvider.request(.dayWeatherCity(changeCity)) { progress in
                var style = ToastStyle()
                style.maxWidthPercentage = 0.8
                self.view.makeToastActivity(.center)
            } completion: { result in
                switch result {
                case let .success(resp):
                    self.view.hideToastActivity()
                    if resp.statusCode == 200 {
                        let json = try! JSON(data: resp.data)
                        if json.count == 2 {
                            var style = ToastStyle()
                            style.fadeDuration = 2
                            style.maxWidthPercentage = 0.8
                            self.view.makeToast("请输入正确的城市", duration: 1, position: .center, style: style)
                        } else {
                            self.currentCityModel = resp.mapObject(DayWeather.self, modelKey: nil)
                            self.doChangeCity(changeCity: changeCity)
                        }
                    }
                case .failure(_):
                    break
                }
            }
            // 重启定时器
            self.startTimer()
        }))
        self.present(alertController, animated: false, completion: nil)
    }
    @objc func addBtnClick() {
        delog("\(#function)")
        // 关闭定时器
        endTimer()
        let alertController = UIAlertController(title: "请输入要添加的城市", message: nil, preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { [weak self] alertAction in
            guard let self = self else {return}
            let addCity = alertController.textFields?[0].text ?? ""
            if addCity == "" {
                // 重启定时器
                self.startTimer()
                return
            }
            self.netManager.weatherProvider.request(.dayWeatherCity(addCity)) { progress in
                var style = ToastStyle()
                style.maxWidthPercentage = 0.8
                self.view.makeToastActivity(.center)
            } completion: { result in
                switch result {
                case let .success(resp):
                    self.view.hideToastActivity()
                    if resp.statusCode == 200 {
                        let json = try! JSON(data: resp.data)
                        if json.count == 2 {
                            var style = ToastStyle()
                            style.fadeDuration = 2
                            style.maxWidthPercentage = 0.8
                            self.view.makeToast("请输入正确的城市", duration: 1, position: .center, style: style)
                        } else {
                            let idx = self.selectCitys.firstIndex(of: addCity)
                            if idx == nil {
                                self.selectCitys.append(addCity)
                                UserDefaults.standard.set(self.selectCitys, forKey: "citys")
                                UserDefaults.standard.synchronize()
                                self.flag = true
                                self.request()
                                
                            }
                        }
                    }
                case .failure(_):
                    break
                }
            }
            //重启定时器
            self.startTimer()
        }))
        self.present(alertController, animated: false, completion: nil)
    }
    @objc func navBackBtnClick() {
        self.navigationController?.popViewController(animated: false)
    }
}
//MARK: - setup UI
private extension SelectCityViewController {
    func setupUI() {
        setupNav()
        self.view.addSubview(self.currentCityLabel)
        self.view.addSubview(self.changeBtn)
        self.view.addSubview(self.currentTableView)
        self.view.addSubview(self.citysLabel)
        self.view.addSubview(self.citysTableView)
        self.view.addSubview(self.addBtn)
        
        prepareCurrentCityLabel()
        prepareChangeBtn()
        prepareCurrentTableView()
        prepareCitysLabel()
        prepareCitysTableView()
        prepareAddBtn()
    }
    func prepareAddBtn() {
        self.addBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.citysLabel.snp.centerY)
            make.right.equalTo(self.citysLabel.snp.right)
            make.width.equalTo(self.citysLabel.snp.height).multipliedBy(0.8)
            make.height.equalTo(self.citysLabel.snp.height).multipliedBy(0.8)
        }
    }
    func prepareCitysTableView() {
        self.citysTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(self.citysLabel.snp.width)
            make.top.equalTo(self.citysLabel.snp.bottom).offset(TOP_SPACE * 0.25)
            make.bottom.equalToSuperview().offset(-SCREEN_HEIGHT * 0.15)
        }
        
    }
    func prepareCitysLabel() {
        self.citysLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.currentTableView.snp.bottom).offset(TOP_SPACE * 0.25)
            make.left.equalTo(self.currentTableView.snp.left)
            make.height.equalTo(self.currentCityLabel.snp.height)
        
        }
    }
    func prepareCurrentTableView() {
        self.currentTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.currentCityLabel.snp.bottom).offset(TOP_SPACE * 0.5)
            make.left.equalTo(self.currentCityLabel.snp.left)
            make.right.equalToSuperview().offset(-TOP_SPACE * 2)
            make.height.equalTo(SCREEN_HEIGHT * 0.075 + TOP_SPACE * 2)
        }
    }
    func prepareChangeBtn() {
        self.changeBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.currentCityLabel.snp.centerY)
            make.right.equalTo(self.currentCityLabel.snp.right)
            make.width.equalTo(self.currentCityLabel.snp.height).multipliedBy(0.8)
            make.height.equalTo(self.currentCityLabel.snp.height).multipliedBy(0.8)
        }
    }
    func prepareCurrentCityLabel() {
        self.currentCityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(SCREEN_HEIGHT * 0.15)
            make.left.equalToSuperview().offset(TOP_SPACE * 2)
            make.height.equalToSuperview().multipliedBy(0.075)
        }
    }
    func setupNav() {
        self.navigationItem.title = "你的城市"
        let height = navigationController?.navigationBar.frame.size.height ?? 44.0
        self.navBackBtn.frame = CGRect(x: -10, y: 0, width: height, height: height)
        let v = UIView(frame: self.navBackBtn.frame)
        v.addSubview(self.navBackBtn)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: v)
    }
}

//MARK: - common
private extension SelectCityViewController {
    func doChangeCity(changeCity: String) {
        let oldCity = Weather.city
        if oldCity != "" && self.selectCitys.firstIndex(of: oldCity) == nil {
            // 旧城市添加进去
            self.selectCitys.append(oldCity)
            self.flag = true
        }
        // 新城市删掉
        if let idx = self.selectCitys.firstIndex(of: changeCity) {
            self.selectCitys.remove(at: idx)
        }
        // 更新用户数据
        UserDefaults.standard.set(changeCity, forKey: "city")
        UserDefaults.standard.set(self.selectCitys, forKey: "citys")
        Weather.city = changeCity
        UserDefaults.standard.synchronize()
        request()
        // 发送一个消息更新其他界面的城市
        NotificationCenter.default.post(name: .init(rawValue: NOTIFICATION_CENTER_UPDATE_CITY), object: nil)
    }
}
