//
//  SelectCityViewController.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/28.
//

import UIKit

class SelectCityViewController: UIViewController {
    
    var city = ""
    private var selectCitys: [String] = {
        return UserDefaults.standard.array(forKey: "selects") as? [String] ?? []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - ui
    private lazy var cityTableView: UITableView = {
        let tv = UITableView();
        tv.delegate = self
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: SELECT_TABLEVIEWCELL_IDENTIFIER)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.separatorStyle = .singleLine
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        return tv
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
//MARK: - tableview delegate & datasouce
extension SelectCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return self.selectCitys.count
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SELECT_TABLEVIEWCELL_IDENTIFIER, for: indexPath) as! SelectTableViewCell
        if indexPath.section == 0 {
            //TODO: - 长按更换
        } else if indexPath.section == 1 {
            //TODO: - 左滑删除
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 5
        }
        return SCREEN_HEIGHT * 0.75 * 0.1
    }
    
}
//MARK: - btn click
private extension SelectCityViewController {
    @objc func navBackBtnClick() {
        self.navigationController?.popViewController(animated: false)
    }
}
//MARK: - setup UI
private extension SelectCityViewController {
    func setupUI() {
        setupNav()
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
