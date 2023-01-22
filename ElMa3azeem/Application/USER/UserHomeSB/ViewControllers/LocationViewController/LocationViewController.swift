//
//  LocationViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/11/2022.
//

import CoreLocation
import GoogleMaps
import GooglePlaces
import UIKit

protocol didPickLocationDelegate: AnyObject {
    func finishPickingLocationWith(location: CLLocationCoordinate2D, address: String)
    func failPickingLocation()
}

class LocationViewController: BaseViewController {
    @IBOutlet weak var gmsMapView: GMSMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!

    // MARK: - Variables

    weak var delegate: didPickLocationDelegate?
    let locationManager = CLLocationManager()
    var camera: GMSCameraPosition?
    let marker = GMSMarker()
    var selecedLocation: CLLocationCoordinate2D?
    var selectedAddress: String?
    var mylocation = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setupStatusBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupStatusBar(color: .appColor(.viewBackGround)!)
        tabBarController?.hideTabbar()
    }

    func setupView() {
        navigationItem.hidesBackButton = true
        setupGoogleMapView()
        locationLabel.text = "Loading...".localized
        chooseButton.setTitle("Choose".localized, for: .normal)

        gmsMapView.isMyLocationEnabled = true
        gmsMapView.settings.myLocationButton = true
        gmsMapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 180, right: 10)
    }

    func setupGoogleMapView() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        gmsMapView.delegate = self
        locationManager.startUpdatingLocation()
    }

    func addMarker(lat: Double, long: Double) {
        let locaiton = CLLocationCoordinate2D(latitude: lat, longitude: long)
        camera = GMSCameraPosition(latitude: locaiton.latitude, longitude: locaiton.longitude, zoom: 16.0)
        marker.position = locaiton
        marker.map = gmsMapView
        marker.isDraggable = true
        marker.icon = #imageLiteral(resourceName: "pin")
        getAddressFromLatLon(
            withLatitude: "\(locaiton.latitude)",
            withLongitude: "\(locaiton.longitude)") { address, _ in
            self.selectedAddress = address
            self.locationLabel.text = self.selectedAddress
        }
        selecedLocation = locaiton

        gmsMapView.animate(to: camera!)
    }

    @IBAction func didPressChooseButton(_ sender: Any) {
        print("the final location is \(selecedLocation ?? CLLocationCoordinate2D())")
        print("the final address is \(selectedAddress ?? "No address")")

        if let location = selecedLocation, let address = selectedAddress {
            // dismiss and return selected location in delegation
            delegate?.finishPickingLocationWith(location: location, address: address)
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Warning!".localized, message: "Please , enable location to detect your location".localized, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .destructive, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings".localized, style: UIAlertAction.Style.default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didPressCloseButton(_ sender: Any) {
        delegate?.failPickingLocation()
        dismiss(animated: true, completion: nil)
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Warning!".localized, message: "Please , enable location to detect your location".localized, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings".localized, style: UIAlertAction.Style.default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }

        locationManager.startUpdatingLocation()
    }
}

extension LocationViewController: GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        addMarker(lat: location.coordinate.latitude, long: location.coordinate.longitude)

        locationManager.stopUpdatingLocation()
        print(location)
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        addMarker(lat: coordinate.latitude, long: coordinate.longitude)
        print(coordinate)
    }

    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let coordinate = mapView.myLocation?.coordinate else { return true }

        camera = GMSCameraPosition(latitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 16.0)
        gmsMapView.animate(to: camera!)
        mylocation = true

        return true
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if mylocation {
            mylocation = false
            var coordinate = CLLocationCoordinate2D()
            coordinate = CLLocationCoordinate2D(latitude: position.target.latitude, longitude: position.target.longitude)
            addMarker(lat: coordinate.latitude, long: coordinate.longitude)
            print(coordinate)
        }
    }
}
