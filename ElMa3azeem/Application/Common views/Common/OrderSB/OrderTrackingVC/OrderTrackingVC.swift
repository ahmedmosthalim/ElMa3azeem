//
//  OrderTrackingVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import CoreLocation
import GoogleMaps
import GooglePlaces
import UIKit

class OrderTrackingVC: BaseViewController {
    @IBOutlet weak var mapView: GMSMapView!

    private let clientMarker = GMSMarker()
    private let storeMarker = GMSMarker()
    private let delegateMarker = GMSMarker()

    var delegateLocation: CLLocationCoordinate2D?
    var storeLocation: CLLocationCoordinate2D?
    var clientLoation: CLLocationCoordinate2D?
    
    var delegateID = Int()
    var orderType: OrderType?
    var orderState: OrderStatus?

    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupocationManger()
        ConnectToSocket()
        setupStatusBar(color: .appColor(.viewBackGround)!)
        addMarkers(clientLat: clientLoation?.latitude ?? 0.0, clientLong: clientLoation?.longitude ?? 0.0, storeLat: storeLocation?.latitude ?? 0.0, storeLong: storeLocation?.longitude ?? 0.0, delegateLat: delegateLocation?.latitude ?? 0.0, delegateLong: delegateLocation?.longitude ?? 0.0)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeStatusBarColor()
    }

    func setupocationManger() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }

    func addMarkers(clientLat: Double, clientLong: Double, storeLat: Double? = 0.0, storeLong: Double? = 0.0, delegateLat: Double, delegateLong: Double) {
        add(marker: clientMarker, lat: clientLat, long: clientLong, image: "home_mark")
        add(marker: delegateMarker, lat: delegateLat, long: delegateLong, image: "delegate_mark")

        if orderType != .specialPackage {
            add(marker: storeMarker, lat: storeLat ?? 0.0, long: storeLong ?? 0.0, image: "store-Mark")
        }

        CATransaction.begin()
        CATransaction.setAnimationDuration(1)

        if orderType == .specialPackage {
            focusMapToShowMarkers(centerLat: delegateLat, centerLong: delegateLong, markers: [clientMarker, delegateMarker])
        } else {
            focusMapToShowMarkers(centerLat: delegateLat, centerLong: delegateLong, markers: [clientMarker, storeMarker, delegateMarker])
        }

        CATransaction.commit()
    }

    func focusMapToShowMarkers(centerLat: Double, centerLong: Double, markers: [GMSMarker]) {
        let centerLocation = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLong)
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: centerLocation, coordinate: centerLocation)

        _ = markers.map {
            bounds = bounds.includingCoordinate($0.position)
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 100))
        }
    }

    func animateDelegateMarker(lat: Double, long: Double, markers: [GMSMarker]) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.8)
        delegateMarker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        CATransaction.commit()

        handleOrderTracking(type: orderType!, status: orderState!, lat: lat, long: long)

        print("update delegate location successfully 💙")
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        SocketConnection.sharedInstance.socket.off("trackorder")
        SocketConnection.sharedInstance.socket.disconnect()
        print("💂🏻‍♀️exitUser")
    }
}

// MARK: - SocketConnection manger

extension OrderTrackingVC {
    @objc private func disConnectSocket(notification: NSNotification) {
        SocketConnection.sharedInstance.socket.off("trackorder")
        let jsonDic = [
            "lat": defult.shared.getData(forKey: .userLat) ?? "",
            "long": defult.shared.getData(forKey: .userLong) ?? "",
            "user_id": defult.shared.user()?.user?.id ?? 0,
        ] as [String: Any]

        SocketConnection.sharedInstance.socket.emit("unsubscribe", jsonDic)
        print("💂🏻‍♀️exitUser")
        SocketConnection.sharedInstance.socket.disconnect()
    }

    @objc func ConnectToSocket() {
        if SocketConnection.sharedInstance.socket.status == .notConnected {
            print("Not connected")
            SocketConnection.sharedInstance.manager.connect()
            SocketConnection.sharedInstance.socket.connect()
        }

        if SocketConnection.sharedInstance.socket.status == .disconnected {
            print("Disconnected")
            SocketConnection.sharedInstance.manager.connect()
            SocketConnection.sharedInstance.socket.connect()
        }

        if SocketConnection.sharedInstance.socket.status == .connecting {
            print("Trying To Connect...")
            SocketConnection.sharedInstance.manager.connect()
            SocketConnection.sharedInstance.socket.connect()
        }

        print(SocketConnection.sharedInstance.socket.status)

        SocketConnection.sharedInstance.socket.once(clientEvent: .connect) { _, _ in
            let jsonDic = [
                "user_id": self.delegateID,
                "tracker_id": defult.shared.user()?.user?.id ?? 0,
            ] as [String: Any]

            SocketConnection.sharedInstance.socket.emit("addtracker", jsonDic)

            self.SockeConFigration()
            print("💂🏻‍♀️AdddUssser : \(jsonDic)")
        }

        if SocketConnection.sharedInstance.socket.status == .connected {
            let jsonDic = [
                "user_id": delegateID,
                "tracker_id": defult.shared.user()?.user?.id ?? 0,
            ] as [String: Any]

            SocketConnection.sharedInstance.socket.emit("addtracker", jsonDic)

            SockeConFigration()
            print("💂🏻‍♀️💂🏻‍♀️💂🏻‍♀️💂🏻‍♀️connected : \(jsonDic)")
        }

        SocketConnection.sharedInstance.socket.on(clientEvent: .error) { data, _ in
            print("🍋Error")
            print("🍉\(data)")
        }

        SocketConnection.sharedInstance.socket.on(clientEvent: .disconnect) { data, _ in
            print("🍋disconnect")
            print("🍉\(data)")
            print("💂🏻‍♀️exitUser")
        }

        SocketConnection.sharedInstance.socket.on(clientEvent: .ping) { data, _ in
            print("🍋Ping")
            print("🍉\(data)")
        }

        SocketConnection.sharedInstance.socket.on(clientEvent: .reconnect) { data, _ in
            print("🍋reconnect")
            print("🍉\(data)")
        }
    }

    // Handle Recive delegate location
    func SockeConFigration() {
        SocketConnection.sharedInstance.socket.on("trackorder") { data, _ in
            print("🌻\(data)")

            var dict = data[0] as! [String: Any]
            print("💙💙\(dict)")

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let lat = dict["lat"] as? Double else { return }
                guard let long = dict["long"] as? Double else { return }

                self.animateDelegateMarker(lat: lat, long: long, markers: [self.clientMarker, self.delegateMarker, self.storeMarker])
            }
        }
    }
}

// MARK: - GMSMapViewDelegate Extension -

extension OrderTrackingVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }

    func add(marker: GMSMarker, lat: Double, long: Double, image: String) {
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let iconView = UserMarkerIconView(image: image)
        marker.iconView = iconView
        marker.map = mapView
    }
}

extension OrderTrackingVC {
    func handleOrderTracking(type: OrderType, status: OrderStatus, lat: Double, long: Double) {
        switch type {
        case .specialStoreWithDelivery, .googleStore:
            if status == .inTransit {
                focusMapToShowMarkers(centerLat: lat, centerLong: long, markers: [clientMarker, delegateMarker])
            } else {
                focusMapToShowMarkers(centerLat: lat, centerLong: long, markers: [clientMarker, storeMarker, delegateMarker])
            }

        case .parcelDelivery:
            if status == .reachedDeliveryLocation {
                focusMapToShowMarkers(centerLat: lat, centerLong: long, markers: [clientMarker, delegateMarker])
            } else {
                focusMapToShowMarkers(centerLat: lat, centerLong: long, markers: [clientMarker, storeMarker, delegateMarker])
            }

        case .specialPackage:
            focusMapToShowMarkers(centerLat: lat, centerLong: long, markers: [clientMarker, delegateMarker])

        case .defult:
            break
        }
    }
}
