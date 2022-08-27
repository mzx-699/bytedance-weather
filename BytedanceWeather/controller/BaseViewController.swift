//
//  BaseViewController.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/30.
//

import UIKit
/// 控制定时器的基类
class BaseViewController: UIViewController {
    
    var timer: DispatchSourceTimer?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // super
    override func viewWillAppear(_ animated: Bool) {
        endTimer()
        request()
        startTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        endTimer()
    }
    func startTimer() {
        
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .default))
        timer?.schedule(deadline: .now() + 60, repeating: 60)
        timer?.setEventHandler {
            self.request()
        }
        timer?.resume()
    }
    func endTimer() {
        if timer != nil {
            timer?.cancel()
            timer = nil
        }
    }
    
    @objc func request() {
        
    }

}
