//
//  MainViewController.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/27.
//

import UIKit
import ESTabBarController_swift
// ESTabBarController_swift 有高亮bug
class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController()
    }


}


private extension MainViewController {
    func addChildViewController() {
        addChildViewController(vc: OverallViewController(), title: "天气预报", imageName: "weather")
        addChildViewController(vc: WeatherDetailViewController(), title: "当日情况", imageName: "detail")
        
        
    }
    
    func addChildViewController(vc: UIViewController, title: String, imageName: String) {
//        vc.tabBarItem = ESTabBarItem(ESBouncesContentView(), title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: imageName + "_sel"))
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: imageName + "_sel"))
        let nav = UINavigationController(rootViewController: vc)
        self.addChild(nav)
    }
}
