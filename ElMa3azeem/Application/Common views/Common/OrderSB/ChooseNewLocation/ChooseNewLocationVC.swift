//
//  ChooseNewLocationVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2011/2022.
//

import CoreLocation
import GoogleMaps
import GooglePlaces
import UIKit

protocol SelectLocationProtocol {
    func saveNewLocation(location: CLLocationCoordinate2D, address: String, title: String)
    func updateLocation(location: CLLocationCoordinate2D, address: String, title: String)
}

class ChooseNewLocationVC: BaseViewController {
    @IBOutlet weak var gmsMapView: GMSMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var locationTitleTf: UITextField!
    @IBOutlet weak var viewTitleLbl: UILabel!

    // MARK: - Variables

    var delegate: SelectLocationProtocol?
    let locationManager = CLLocationManager()
    var camera: GMSCameraPosition?
    let marker = GMSMarker()
    var selecedLocation: CLLocationCoordinate2D?
    var selectedAddress: String?
    var mylocation = false

    var viewTitle = ""
    var add: Address?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if viewTitle == "new" {
            viewTitleLbl.text = "Add new location".localized
        } else {
            viewTitleLbl.text = "Edit location".localized
            editLocation(lat: add?.lat ?? "", long: add?.long ?? "", title: add?.title ?? "", address: add?.address ?? "")
        }

        setupStatusBar(color: .appColor(.viewBackGround)!)
        tabBarController?.hideTabbar()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setupStatusBar(color: .clear)
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
    }

    func editLocation(lat: String, long: String, title: String, address: String) {
        addMarker(lat: Double(lat) ?? 0, long: Double(long) ?? 0)
        locationTitleTf.text = title
        locationLabel.text = address
    }

    @IBAction func didPressChooseButton(_ sender: Any) {
        print("the final location is \(selecedLocation ?? CLLocationCoordinate2D())")
        print("the final address is \(selectedAddress ?? "No address")")

        if let location = selecedLocation, let address = selectedAddress {
            // dismiss and return selected location in delegation
            if viewTitle == "new" {
                delegate?.saveNewLocation(location: location, address: address, title: locationTitleTf.text ?? "")
            } else {
                delegate?.updateLocation(location: location, address: address, title: locationTitleTf.text ?? "")
            }
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
        locationTitleTf.text = title
        selecedLocation = locaiton

        gmsMapView.animate(to: camera!)
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func didPressCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ChooseNewLocationVC: CLLocationManagerDelegate {
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

extension ChooseNewLocationVC: GMSMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if viewTitle == "new" {
            marker.map = nil
            guard let location = locations.last else { return }

            addMarker(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        }

        locationManager.stopUpdatingLocation()
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
