//
//  MainViewController.swift
//  SkyWalker
//
//  Created by 杨烁 on 2018/6/7.
//  Copyright © 2018年 杨烁. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,MAMapViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        let r = MAUserLocationRepresentation()
        mapView.update(r)
        signalLocation()
    }

    func signalLocation(){
        locationManager.requestLocation(withReGeocode: false, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in

            if let error = error {
                let error = error as NSError

                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {

                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                }
            }

            if let location = location {
                NSLog("location:%@", location)
            }

            if let reGeocode = reGeocode {
                NSLog("reGeocode:%@", reGeocode)
            }
        })
    }



    lazy var mapView:MAMapView = {
        let mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }()

    lazy var locationManager:AMapLocationManager = {
        let location = AMapLocationManager.init()
        location.desiredAccuracy = kCLLocationAccuracyBest
        location.locationTimeout = 10
        location.reGeocodeTimeout = 10
        return location
    }()

}
