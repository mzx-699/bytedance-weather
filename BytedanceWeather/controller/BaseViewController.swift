//
//  BaseViewController.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/30.
//

import UIKit

class BaseViewController: UIViewController {

    var timer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        endTimer()
        request()
        startTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        endTimer()
    }
    func startTimer() {
        delog("\(#function)")
        timer = .scheduledTimer(withTimeInterval: 60, repeats: true, block: { [weak self] _ in
            guard let self = self else {return}
//            self.request()
        })
    }
    func endTimer() {
        delog("\(#function)")
        timer?.invalidate()
        if timer != nil {
            timer = nil
        }
    }
    
    @objc func request() {
        
    }

}