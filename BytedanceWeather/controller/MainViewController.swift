//
//  MainViewController.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/27.
//

import UIKit
import ESTabBarController_swift

class MainViewController: ESTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController()
    }

}


private extension MainViewController {
    func addChildViewController() {
        addChildViewController(vc: OverallViewController(), title: "天气预报", imageName: "")
        addChildViewController(vc: WeatherDetailViewController(), title: "当日情况", imageName: "")
    }
    
    func addChildViewController(vc: UIViewController, title: String, imageName: String) {
        //设置标题---由内至外设置的
        //设置图像
//        vc.tabBarItem.image = UIImage(named: imageName)
        //导航控制器
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        addChild(nav)
    }
}
