//
//  ChooseStoreVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1311/2022.
//

import UIKit
 
import GooglePlaces
import GoogleMaps
import CoreLocation

protocol selectBranchProtocol {
    func selectBranch(id : Int)
}

class ChooseStoreVC: BaseViewController {
    
    @IBOutlet weak var filterTf: UITextField!
    @IBOutlet weak var listBtn: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var mapView:GMSMapView!
    
    var delegate : selectBranchProtocol?
    var isShowMap = true
    var isFilterd = false
    let locationManager = CLLocationManager()
    var camera:GMSCameraPosition?
    let marker = GMSMarker()
    
    var currentBranch : Branch?
    var branchesArray = [Branch]()
    var filterdArray = [Branch]()
    var markers = [GMSMarker]()
    var storeID = Int()
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStoreBranchesData(id: "\(storeID)")
        setupView()
    }
    
    func setupView() {
        setupGoogleMapView()
        self.mapView.camera = GMSCameraPosition(latitude: Double(defult.shared.getData(forKey: .userLat) ?? "") ?? 0.0, longitude: Double(defult.shared.getData(forKey: .userLong) ?? "") ?? 0.0, zoom: 10)
        self.filterTf.delegate = self
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 10)
        
        if isShowMap {
            listBtn.backgroundColor = .appColor(.viewBackGround)
            mapView.isHidden = false
            listTableView.isHidden = true
        }else{
            listBtn.backgroundColor = UIColor.appColor(.MainColor)
            mapView.isHidden = true
            listTableView.isHidden = false
        }
        listTableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 16, right: 0)
        listTableView.tableFooterView = UIView()
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.register(UINib(nibName: "BranchCell", bundle: nil), forCellReuseIdentifier: "BranchCell")
    }
    
    func setupGoogleMapView() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
    }
    
    func drowMarkers (branckes : [Branch]) {
        branckes.forEach { branch in
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(branch.lat) ?? 0.0, longitude: Double(branch.long) ?? 0.0)
            let markerIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            markerIcon.layer.cornerRadius = markerIcon.frame.height / 2
            markerIcon.setImage(image: branch.icon, loading: true)
            markerIcon.layer.borderWidth = 5
            
            if branch.isSelected == true {
                markerIcon.layer.borderColor = UIColor.appColor(.MainColor)?.cgColor
            }else{
                markerIcon.layer.borderColor = UIColor.appColor(.BorderColor)?.cgColor
            }
            
            markerIcon.clipsToBounds = true
            marker.iconView = markerIcon
            marker.map = self.mapView
            marker.userData = branch
            markers.append(marker)
        }
    }
    
    func selectList () {
        self.listBtn.backgroundColor = UIColor.appColor(.MainColor)
        self.listBtn.setImage(UIImage(named: "menu_white"), for: .normal)
        self.isShowMap = false
        self.mapView.alpha = 0
        self.listTableView.alpha = 1
        self.mapView.isHidden = true
        self.listTableView.isHidden = false
        self.listTableView.reloadWithAnimation()
    }
    
    func selectMap() {
        self.listBtn.backgroundColor = .white
        self.listBtn.setImage(UIImage(named: "menu"), for: .normal)
        self.mapView.alpha = 1
        self.listTableView.alpha = 0
        self.isShowMap = true
        self.mapView.isHidden = false
        self.listTableView.isHidden = true
    }
    
    //    MARK: - Actions -
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func listAction(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4) {
            if self.isShowMap {
                self.selectList()
            }else{
                self.selectMap()
            }
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        delegate?.selectBranch(id: currentBranch?.id ?? 0)
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChooseStoreVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Alert.showAlertWithAction(target: self, title: "Warning!".localized, message: "Please , enable location to detect your location".localized, okAction: "ok".localized, actionCompletion: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
    }
}

//MARK: - TableView Extension -
extension ChooseStoreVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilterd {
            return filterdArray.count
        }else{
            return branchesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BranchCell", for: indexPath) as! BranchCell
        if isFilterd {
            cell.configCell(branch: filterdArray[indexPath.row], current: currentBranch?.id ?? 0)
        }else{
            cell.configCell(branch: branchesArray[indexPath.row], current: currentBranch?.id ?? 0)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFilterd {
            self.currentBranch = filterdArray[indexPath.row]
            for i in branchesArray.indices {
                
                if self.currentBranch?.id == branchesArray[i].id {
                    self.branchesArray[i].isSelected = true
                    self.filterdArray[indexPath.row].isSelected = true
                }else{
                    self.branchesArray[i].isSelected = false
                    for x in filterdArray.indices {
                        if currentBranch?.id != filterdArray[x].id {
                            self.filterdArray[indexPath.row].isSelected = false
                        }
                    }
                }
                
            }
            
            listTableView.reloadData()
            self.mapView.clear()
            self.drowMarkers(branckes: self.filterdArray)
            
        }else{
            self.currentBranch = branchesArray[indexPath.row]
            
            for i in branchesArray.indices {
                if self.currentBranch?.id == branchesArray[i].id {
                    self.branchesArray[i].isSelected = true
                }else{
                    self.branchesArray[i].isSelected = false
                }
            }
            
            listTableView.reloadData()
            self.mapView.clear()
            self.drowMarkers(branckes: self.branchesArray)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
}


//MARK: - delegate
extension ChooseStoreVC : UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchText = textField.text ?? ""
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchAction(_:)), object: nil)
        self.perform(#selector(searchAction), with: nil, afterDelay: 0.5)

    }
    
    @objc func searchAction(_ textField: UITextField) {
        print(searchText)
        
        if searchText != "" {
            isFilterd = true
        
            filterdArray = branchesArray.filter {$0.address.contains(searchText)}
            mapView.clear()
            drowMarkers(branckes: filterdArray)
            listTableView.reloadWithAnimation()
            
        }else{
            isFilterd = false
            
            mapView.clear()
            drowMarkers(branckes: branchesArray)
            listTableView.reloadWithAnimation()
        }
    }
}

//    MARK: - GMSMapViewDelegate Extension -
extension ChooseStoreVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let currentBranch = marker.userData as? Branch{
            self.currentBranch = currentBranch
            var x = 0
            for branch in branchesArray {
                if currentBranch.id == branch.id {
                    branchesArray[x].isSelected = true
                    mapView.camera = GMSCameraPosition(latitude: Double(branch.lat) ?? 0.0, longitude: Double(branch.long) ?? 0.0, zoom: self.mapView.camera.zoom)
                }else{
                    branchesArray[x].isSelected = false
                }
                x += 1
            }
        }
        
        self.mapView.clear()
        
        self.drowMarkers(branckes: branchesArray)
        
        return true
    }
}

//MARK: - API Extention -
extension ChooseStoreVC {
    func getStoreBranchesData (id : String) {
        self.showLoader()
        CreateOrderNetworkRouter.storeBranches(id: id, lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "").send(GeneralModel<BranchesModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getStoreBranchesData(id: id)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.branches.isEmpty == false {
                        
                        self.listBtn.isEnabled = true
                        self.mapView.isHidden = false
                        
                        self.branchesArray.append(contentsOf: data.data?.branches ?? [])
                        self.drowMarkers(branckes: data.data?.branches ?? [])
                    }else{
                        self.listTableView.isHidden = true
                        self.mapView.isHidden = true
                        self.listBtn.isEnabled = false
                    }
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
}


