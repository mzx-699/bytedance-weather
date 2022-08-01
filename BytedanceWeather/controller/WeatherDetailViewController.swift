//
//  RedViewController.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/27.
//

import UIKit

class WeatherDetailViewController: BaseViewController {

    // 网络
    let netManager = NetManager()
    //MARK: - model
    var dayWeatherModel: DayWeather? = DayWeather.fromCache(key: Weather.city + "-" + DAYWEATHER_CACHE_KEY, cacheContainer: .hybrid)
    var dailyWordModel: DailyWord? = DailyWord.fromCache(key: DAILYWORD_CACHE_KEY, cacheContainer: .hybrid)
    var dayWeatherMap: Dictionary<String, String>?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initNetDelegate()
        request()
        self.netManager.dailyWordRequest(type: .recommend)
        NotificationCenter.default.addObserver(forName: .init(rawValue: NOTIFICATION_CENTER_UPDATE_CITY), object: nil, queue: nil) { [weak self] _ in
            guard let self = self else {return}
            delog("\(#function)")
            self.request()
        }
    }
    //MARK: - 加载plist文件
    private lazy var contents: [Array<Dictionary<String, String>>] = {
        let path = Bundle.main.path(forResource: "details.plist", ofType: nil)
        let url = URL(fileURLWithPath: path!)
        let arr = try! NSArray(contentsOf: url, error: ())
        return arr as! [Array<Dictionary<String, String>>]
    }()
    //MARK: - 父类
    override func request() {
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
    private lazy var centerDailyWordLabel: UILabel = {
        let label = UILabel()
        label.text = self.dailyWordModel?.content ?? "秋招好难啊～秋招好难啊～秋招好难啊～秋招好难啊～"
        label.textColor = .gray
        label.alpha = 0.6
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
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
    private lazy var detailTableView: UITableView = {
        let tv = UITableView();
        tv.delegate = self
        tv.dataSource = self
        tv.register(DetailTableViewCell.self, forCellReuseIdentifier: DETAIL_TABLEVIEWCELL_IDENTIFIER)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .singleLine
        tv.isScrollEnabled = false
        tv.tableFooterView = UIView()
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return tv
    }()
}

//MARK: - tableview delegate & datasouce
extension WeatherDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contents.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return UITableViewCell()
        }
        let arr = self.contents[indexPath.section - 1]
        let cell = tableView.dequeueReusableCell(withIdentifier: DETAIL_TABLEVIEWCELL_IDENTIFIER, for: indexPath) as! DetailTableViewCell
        cell.selectionStyle = .none
        cell.leftTitleLabel.text = arr[0]["title"]
        cell.rightTitleLabel.text = arr[1]["title"]
        let lk = arr[0]["key"]!
        let rk = arr[1]["key"]!
        cell.leftContentLabel.text = self.dayWeatherMap?[lk] ?? arr[0]["content"]
        cell.rightContentLabel.text = self.dayWeatherMap?[rk] ?? arr[1]["content"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 5
        }
        return SCREEN_HEIGHT * 0.1
    }
    
}
//MARK: - net delegate
extension WeatherDetailViewController: DailyWordDelegate, WeaetherDelegate {
    
    func acquireDailyWordCache(model: DailyWord) {
        self.dailyWordModel = model
        updateDailyWordData()
    }
    
    func acquireWeekWeatherCache(model: WeekWeather) {}
    
    func acquireDayWeatherCache(model: DayWeather) {
        self.dayWeatherModel = model
        updateDayWeatherData()
    }
    
    func initNetDelegate() {
        self.netManager.weatherDelegate = self
        self.netManager.dailyWordDelegate = self
    }
    func acquireDayWeather(model: DayWeather) {
        self.dayWeatherModel = model
        updateDayWeatherData()
    }
    func acquireWeekWeather(model: WeekWeather) {
    }
    func acquireDailyWord(model: DailyWord) {
        self.dailyWordModel = model
        updateDailyWordData()
    }
    // 获得请求数据后，需要更新
    func updateDayWeatherData() {
        self.dayWeatherModel?.cache(key: Weather.city + "-" + DAYWEATHER_CACHE_KEY, cacheContainer: .hybrid)
        self.navigationItem.title = self.dayWeatherModel!.city!
        self.temLabel.text = self.dayWeatherModel!.tem! + "℃"
        self.weaLabel.text = self.dayWeatherModel!.wea!
        self.dayWeatherMap = getDayWeatherMap(day: self.dayWeatherModel!)
        detailTableView.reloadData()
        
    }
    func updateDailyWordData() {
        self.dailyWordModel?.cache(key: DAILYWORD_CACHE_KEY, cacheContainer: .hybrid)
        self.centerDailyWordLabel.text = self.dailyWordModel!.content
        self.detailTableView.snp.updateConstraints { make in
            make.top.equalTo(self.centerDailyWordLabel.snp.bottom).offset(TOP_SPACE * 2)
        }
    }
    
}
//MARK: - setupUI
private extension WeatherDetailViewController {
    func setupUI() {
        setupNav()
        self.view.addSubview(self.temLabel)
        self.view.addSubview(self.centerDailyWordLabel)
        self.view.addSubview(self.weaLabel)
        self.view.addSubview(self.detailTableView)
        prepareTemLabel()
        prepareCenterDailyWordLabel()
        prepareWeaLabel()
        prepareDetailTableView()
    }
    func prepareDetailTableView() {
        self.detailTableView.snp.makeConstraints { make in
            make.centerX.equalTo(self.temLabel.snp.centerX)
            make.top.equalTo(self.centerDailyWordLabel.snp.bottom).offset(TOP_SPACE * 2)
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
    func prepareCenterDailyWordLabel() {
        self.centerDailyWordLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.temLabel.snp.centerX)
            make.width.equalToSuperview().multipliedBy(0.8)
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
        
    }
}
