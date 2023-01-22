//
//  SavedLocationVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2011/2022.
//

import CoreLocation
import UIKit

protocol SelectDelieryLocationProtocol {
    func selectLocation(address: Address)
}

class SavedLocationVC: BaseViewController {
    
    enum PreviousVC {
        case moreVC
        case other
    }
    
    @IBOutlet weak var savedLocationTableview   : UITableView!
    @IBOutlet weak var noDataImage              : UIImageView!
    @IBOutlet weak var noDataStack              : UIStackView!
    @IBOutlet weak var addNewAddressBtn         : SpaceingImageButton!
    
    var locattionsArray = [Address]()
    var editAddressID = Int()
    var indexpath = IndexPath()
    var delegate: SelectDelieryLocationProtocol?
    var previousVC : PreviousVC = .other

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        switch previousVC {
        case .moreVC:
            self.tabBarController?.hideTabbar()
        case .other:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeStatusBarColor()
    }

    
    private func noData(){
        noDataImage.isHidden = !locattionsArray.isEmpty
        noDataStack.isHidden = !locattionsArray.isEmpty
        savedLocationTableview.isHidden = locattionsArray.isEmpty
    }
    func setupView() {
        savedLocationTableview.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 100, right: 0)
        savedLocationTableview.delegate = self
        savedLocationTableview.dataSource = self
        savedLocationTableview.register(UINib(nibName: "SavedLocationCell", bundle: nil), forCellReuseIdentifier: "SavedLocationCell")
        getSavedLocation()
        
        addNewAddressBtn.imagePadding(spacing: 8)
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func chooseLocationFromMapAction(_ sender: Any) {
        let vc = AppStoryboards.Order.instantiate(ChooseNewLocationVC.self)
        vc.viewTitle = "new"
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView Extension -

extension SavedLocationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locattionsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedLocationCell", for: indexPath) as! SavedLocationCell
        cell.configCell(item: locattionsArray[indexPath.row])

        cell.deleteAddress = { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DeleteLocationPopup") as! DeleteLocationPopup
            vc.delete = {
                self.deleteLocation(addressID: self.locattionsArray[indexPath.row].id, index: indexPath)
            }
            self.present(vc, animated: true, completion: nil)
        }

        cell.editAddress = { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChooseNewLocationVC") as! ChooseNewLocationVC
            vc.viewTitle = "edit"
            vc.add = self.locattionsArray[indexPath.row]
            vc.delegate = self
            self.indexpath = indexPath
            self.editAddressID = self.locattionsArray[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch previousVC {
        case .moreVC:
            break
        case .other:
            let address = locattionsArray[indexPath.row]
            delegate?.selectLocation(address: address)
            navigationController?.popViewController(animated: true)
        }
       
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Delegate Extension -

extension SavedLocationVC: SelectLocationProtocol {
    func saveNewLocation(location: CLLocationCoordinate2D, address: String, title: String) {
        addLocation(title: title, lat: "\(location.latitude)", long: "\(location.longitude)", address: address)
    }

    func updateLocation(location: CLLocationCoordinate2D, address: String, title: String) {
        editLocation(addressID: editAddressID, title: title, lat: "\(location.latitude)", long: "\(location.longitude)", address: address, index: indexpath)
    }
}

// MARK: - API Extension -

extension SavedLocationVC {
    func getSavedLocation() {
        showLoader()
        CreateOrderNetworkRouter.addressBook.send(GeneralModel<AddressModel>.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                self.showError(error: error.localizedDescription)
            case let .success(data):
                self.hideLoader()
                if data.key == ResponceStatus.success.rawValue {
                    self.locattionsArray.append(contentsOf: data.data?.addresses ?? [])
                    self.savedLocationTableview.reloadData()
                    self.noData()
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func addLocation(title: String, lat: String, long: String, address: String) {
        showLoader()
        CreateOrderNetworkRouter.addAddress(title: title, lat: lat, long: long, address: address).send(GeneralModel<AddressModel>.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                self.showError(error: error.localizedDescription)
            case let .success(data):
                self.hideLoader()
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: data.msg)
                    self.locattionsArray.removeAll()
                    self.getSavedLocation()
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func deleteLocation(addressID: Int, index: IndexPath) {
        showLoader()
        CreateOrderNetworkRouter.deleteAddress(addressID: "\(addressID)").send(GeneralModel<AddressModel>.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                self.showError(error: error.localizedDescription)
            case let .success(data):
                self.hideLoader()
                if data.key == ResponceStatus.success.rawValue {
                    self.locattionsArray.remove(at: index.row)
                    self.savedLocationTableview.reloadData()
                    
                    let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue, bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SuccessDeleteLocationPopup") as! SuccessDeleteLocationPopup
                    self.present(vc, animated: true, completion: nil)
                    if self.locattionsArray.isEmpty == true {
                        self.savedLocationTableview.isHidden = true
                    }
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func editLocation(addressID: Int, title: String, lat: String, long: String, address: String, index: IndexPath) {
        showLoader()
        CreateOrderNetworkRouter.editAddress(addressID: "\(addressID)", title: title, lat: lat, long: long, address: address).send(GeneralModel<AddressModel>.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                self.showError(error: error.localizedDescription)
            case let .success(data):
                self.hideLoader()
                if data.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: data.msg)
                    self.locattionsArray.removeAll()
                    self.getSavedLocation()
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}
