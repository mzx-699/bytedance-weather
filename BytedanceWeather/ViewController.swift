//
//  ViewController.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/25.
//

import UIKit
import Moya
import SwiftyJSON
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 350, height: 350))
        label.text = "hello"
        self.view.addSubview(label)
        
        let WeatherProvider = MoyaProvider<WeatherAPI>()
        WeatherProvider.request(.dayWeather) { result in
            switch result {
            case let .success(resp):
                if resp.statusCode == 200,
                   let json = try? JSON(data: resp.data) {
                    let dw = DayWeather(json: json)
                    print(dw.description)
                }
                break
            case let .failure(moyaError):
                print(moyaError)
                break
            }
        }
    }


}

