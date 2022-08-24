//
//  WeatherLocation.swift
//  BytedanceWeather
//
//  Created by 麻志翔 on 2022/7/31.
//

import UIKit
import SVProgressHUD
//定位
import CoreLocation
import Reachability
/// App 定位类
class WeatherLocation : NSObject {
    
    static let shareInstance = WeatherLocation.init()
    let reachability = try! Reachability()
    /// 获取最新定位信息
    var getLocationInfo:((_ _country:String?,_ _province:String?,_ _city:String?,_ _county:String?)->Void)?
    
    //初始化
    override init() {
        super.init()
        self.locationInit()
    }
    
    deinit {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.delegate = nil
        self.locationManager = nil
        print("\(self) 已销毁")
    }
    
    
    //MARK: - lazy load
    /// 定位对象
    private lazy var locationManager:CLLocationManager? = nil
}
 
 
//MARK: -
extension WeatherLocation {
    
    /// 定位初始化
    private func locationInit(){
        //定位对象
        self.locationManager = CLLocationManager.init()
        weak var weakSelf = self
        self.locationManager?.delegate = weakSelf
        
        /**
         设置精度
         kCLLocationAccuracyBest             精确度最佳
         kCLLocationAccuracyNearestTenMeters 精确度10m以内
         kCLLocationAccuracyHundredMeters    精确度100m以内
         kCLLocationAccuracyKilometer        精确度1000m以内
         kCLLocationAccuracyThreeKilometers  精确度3000m以内
         */
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        //设置间隔距离(单位：m) 内更新定位信息
        //定位要求的精度越高，distanceFilter属性的值越小，应用程序的耗电量就越大。
        self.locationManager?.distanceFilter = 200.0
    }
    
    /// 权限检测
    private func locationPermissionsCheck(){
        if CLLocationManager.locationServicesEnabled() == false {
            SVProgressHUD.showInfo(withStatus: "请确认已开启定位服务")
            openSetting(urlString: "prefs:root=LOCATION_SERVICES")
            return
        }
        
        // 请求用户授权
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager?.requestWhenInUseAuthorization()
        }
        
        SVProgressHUD.dismiss()
    }
    
    /// 反编码获取地址信息
    private func getGeocoderInfoFor(Location location:CLLocation){
        
        // 如果断网或者定位失败
        if  reachability.connection == .unavailable {
            print("没有网络无法反编码地址")
            SVProgressHUD.showInfo(withStatus: "开启网络后重试")
            openSetting(urlString: UIApplication.openSettingsURLString)
            return
        }
        let userDefaultLanguages = UserDefaults.standard.array(forKey: "AppleLanguages")
        // 转成中文
        UserDefaults.standard.set(["zh-hans"], forKey: "AppleLanguages")
        let currLocation:CLLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currLocation) {[weak self] (pls:[CLPlacemark]?, error:Error?) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error.debugDescription)
                return
            }
            guard let self = self else { return }
            guard let placemarks = pls,placemarks.count > 0 else {
                SVProgressHUD.showInfo(withStatus: "获取地理信息失败，请重试")
                return
            }
            
            /*
             * region:                               //地理区域
             * addressDictionary:[AnyHashable : Any] //可以使用ABCreateStringWithAddressDictionary格式化为一个地址
             * thoroughfare: String?                 //街道名
             * name:String?                          //地址
             * subThoroughfare: String?              //大道
             * locality: String?                     //城市
             * subLocality: String?                  // 社区,通用名称
             * administrativeArea: String?           // state, eg. CA
             * subAdministrativeArea: String?        // 国家, eg. Santa Clara
             * postalCode: String?                   // zip code, eg. 95014
             * isoCountryCode: String?               // eg. US
             * country: String?                      // eg. United States
             * inlandWater: String?                  // 湖泊
             * ocean: String?                        // 洋
             * areasOfInterest: [String]?            // 感兴趣的地方
             */
            let placeMark:CLPlacemark = placemarks[0]
            print("定位信息：\(String(describing: placeMark))")
            
            //当前城市
            let strCurrentCity = placeMark.locality
            
            
            //国家
            let strCurrentCountry = placeMark.country
            
            //省份(直辖市时，省份没有)
            var strCurrentProvince = placeMark.administrativeArea
            if strCurrentProvince == nil {
                strCurrentProvince = placeMark.locality
            }
            
            //区(县)
            let strCurrentArea = placeMark.subLocality
            
            //闭包回调
            self.getLocationInfo?(
                strCurrentCountry,
                strCurrentProvince,
                strCurrentCity,
                strCurrentArea
            )
            UserDefaults.standard.set(userDefaultLanguages, forKey: "AppleLanguages")
            //关闭定位
            self.locationManager?.stopUpdatingLocation()
            
            SVProgressHUD.dismiss()
        }
    }
    
    /// 开启定位
    func startLoaction(){
        
        SVProgressHUD.show(withStatus: "定位中...")
        
        //已开启定位服务
        if CLLocationManager.locationServicesEnabled() {
            //是否有授权本App获取定位
            var _auth:CLAuthorizationStatus?
            if #available(iOS 14.0, *) {
                _auth = self.locationManager?.authorizationStatus
            } else {
                // Fallback on earlier versions
                _auth = CLLocationManager.authorizationStatus()
            }
            
            if _auth == nil || _auth == .denied || _auth == .restricted {
                SVProgressHUD.dismiss()
                openSetting(urlString: UIApplication.openSettingsURLString)
                return
            }
            
            //可以定位
            self.locationManager?.startUpdatingLocation()
        }
        else{
            self.locationPermissionsCheck()
        }
    }
    
    func openSetting(urlString: String) {
        let url = NSURL(string: urlString)! as URL
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
 
 
//MARK: - CLLocationManagerDelegate
extension WeatherLocation : CLLocationManagerDelegate {
    
    /// 定位失败
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败：\(error.localizedDescription)")
        self.locationManager?.requestWhenInUseAuthorization()
        //SVProgressHUD.showInfo(withStatus: error.localizedDescription)
    }
    
    /// 定位成功
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("定位成功")
        
        /**
         * CLLocation 定位信息
         *
         * 经度：currLocation.coordinate.longitude
         * 纬度：currLocation.coordinate.latitude
         * 海拔：currLocation.altitude
         * 方向：currLocation.course
         * 速度：currLocation.speed
         *  ……
         */
        if let _location = locations.last {
            self.getGeocoderInfoFor(Location: _location)
        }
        else{
            SVProgressHUD.showInfo(withStatus: "请稍后重试")
        }
    }
}
