//
//  StoreSettingVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 03/11/2022.
//

import CoreLocation
import SwiftUI
import UIKit

class StoreSettingVC: BaseViewController {
    // MARK: - OutLets

    // main
    @IBOutlet weak var storeSettingBtn: RoundedButton!
    @IBOutlet weak var workTimeBtn: RoundedButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var timeTitleStackView: UIView!

    // data
    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var storeCover: UIImageView!
    @IBOutlet weak var storeCoverView: AppTextFieldViewStyle!
    @IBOutlet weak var storeCoverImageTf: AppTextFieldStyle!
    @IBOutlet weak var storeNameInArabicTf: AppTextFieldStyle!
    @IBOutlet weak var storeNameInEnglishTf: AppTextFieldStyle!
    @IBOutlet weak var categoryTf: AppPickerTextFieldStyle!
    @IBOutlet weak var locationView: AppTextFieldViewStyle!
    @IBOutlet weak var locationTf: AppTextFieldStyle!
    @IBOutlet weak var bankAccountNumberTf: AppTextFieldStyle!
    @IBOutlet weak var ibanTf: AppTextFieldStyle!
    @IBOutlet weak var bankNameTf: AppTextFieldStyle!
    @IBOutlet weak var commercialIDTf: AppTextFieldStyle!
    @IBOutlet weak var commercialPhotoView: AppTextFieldViewStyle!
    @IBOutlet weak var commercialImageView: UIImageView!

    // MARK: - Variables

    private var categories = [Category]()
    var providerData: StoreDetailsData?

    private var location: CLLocationCoordinate2D?
    private var imageType: ImageType = .notAny
    private var coverImageData: Data?
    private var storeImageData: Data?
    private var commercialImageData: Data?

    enum ImageType {
        case cover
        case image
        case commercial
        case notAny
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
        removeStatusBarColor()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        providerData = defult.shared.provider()
        setupView()
        getCategories()
    }

    // MARK: - CONFIGRATION

    private func configGestures() {
        storeCoverView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.coverTapped()
        }

        locationView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.locationTapped()
        }

        storeImage.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.imageTapped()
        }
        commercialPhotoView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.commercialTapped()
        }
    }

    @objc func coverTapped() {
        imageType = .cover
        uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }

    @objc func imageTapped() {
        imageType = .image
        uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }

    @objc func commercialTapped() {
        imageType = .commercial
        uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }

    @objc func locationTapped() {
        navigateToChooseLoation()
    }

    private func setupView() {
        storeSettingBtn.selectButton()
        workTimeBtn.notSelectButton()
        infoStackView.isHidden = false
        tableView.isHidden = true
        timeTitleStackView.isHidden = tableView.isHidden
        tableViewConfigration()
        configGestures()
        configUI()
    }

    private func tableViewConfigration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(type: StoreWorkTimeCell.self)
    }

    private func ValidateData(nameAr: String, nameEn: String, category: String, location: CLLocationCoordinate2D, address: String, baankAccountNumber: String, ibanNumber: String, bankName: String, commirtialID: String) throws {
        try ValidationService.validate(nameAr: nameAr)
//        try ValidationService.validate(nameEn: nameEn)
        try ValidationService.validate(category: category)
        _ = try ValidationService.validate(address: address, lat: Double(location.latitude), long: Double(location.longitude))
        try ValidationService.validate(bankName: bankName)
        try ValidationService.validate(baankAccountNumber: baankAccountNumber)
        try ValidationService.validate(commirtialID: commirtialID)
        try ValidationService.validate(ibanNumber: ibanNumber)
    }

    private func configUI() {
        locationTf.text = providerData?.address
        ibanTf.text = providerData?.ibanNumber
        storeNameInArabicTf.text = providerData?.nameAr
        storeNameInEnglishTf.text = providerData?.nameEn
        bankAccountNumberTf.text = providerData?.bankNumber
        bankNameTf.text = providerData?.bankName
        commercialIDTf.text = providerData?.commercialId
        storeImage.setImage(image: providerData?.icon ?? "", loading: true)
        storeCover.setImage(image: providerData?.cover ?? "", loading: true)
        commercialImageView.setImage(image: providerData?.commercialImage ?? "", loading: true)
        location = CLLocationCoordinate2D(latitude: Double(providerData?.lat ?? "") ?? 0.0, longitude: Double(providerData?.long ?? "") ?? 0.0)
        tableView.reloadWithAnimation()
        infoStackView.reloadData(animationDirection: .down)
    }

    // MARK: - NAVIGATIONS

    private func navigateToChooseLoation() {
        let vc = AppStoryboards.Home.instantiate(LocationViewController.self)
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - ACTION

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func storeSettingAction(_ sender: Any) {
        storeSettingBtn.selectButton()
        workTimeBtn.notSelectButton()

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.tableView.alpha = 0
            self.infoStackView.alpha = 1
            self.tableView.isHidden = true
            self.infoStackView.isHidden = false
            self.timeTitleStackView.isHidden = self.tableView.isHidden
            self.containerView.backgroundColor = .appColor(.viewBackGround)
        }
    }

    @IBAction func workTimeAction(_ sender: Any) {
        workTimeBtn.selectButton()
        storeSettingBtn.notSelectButton()
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.tableView.alpha = 1
            self.infoStackView.alpha = 0
            self.tableView.isHidden = false
            self.infoStackView.isHidden = true
            self.timeTitleStackView.isHidden = self.tableView.isHidden
            self.containerView.backgroundColor = .clear
        }
    }

    @IBAction func confirmAction(_ sender: Any) {
        do {
            try ValidateData(nameAr: storeNameInArabicTf.text ?? "", nameEn: storeNameInEnglishTf.text ?? "", category: categoryTf.text ?? "", location: location!, address: locationTf.text ?? "", baankAccountNumber: bankAccountNumberTf.text ?? "", ibanNumber: ibanTf.text ?? "", bankName: bankNameTf.text ?? "", commirtialID: commercialIDTf.text ?? "")

            var dayes = [ApiDayModel]()
            for day in providerData?.openingHours ?? [] {
                if day.fromTime ?? Date() >= day.toTime ?? Date() {
                    showError(error: "Please confirm all start time must be before the closing time.".localized)
                    return
                }

                dayes.append(ApiDayModel(days: day.key ?? "", from: day.apiFrom, to: day.apiTo))
            }

            print(dayes)
            guard let loaction = location else { return }
            updateStoreDetails(nameAr: storeNameInArabicTf.text ?? "", nameEn: storeNameInEnglishTf.text ?? "", category: categoryTf.selectedPickerData?.pickerKey ?? "", location: loaction, address: locationTf.text ?? "", bankAccountNumber: bankAccountNumberTf.text ?? "", ibanNumber: ibanTf.text ?? "", bankName: bankNameTf.text ?? "", commirtialID: commercialIDTf.text ?? "", days: dayes.toString(), icon: storeImageData, cover: coverImageData, commercialImage: commercialImageData)

        } catch {
            showError(error: error.localizedDescription)
        }
    }
}

// MARK: - Picker Extention

extension StoreSettingVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as! UIImage? {
            let imageData = image.jpegData(compressionQuality: 0.4)!

            switch imageType {
            case .cover:
                storeCover.image = image
                coverImageData = imageData
            case .image:
                storeImage.image = image
                storeImageData = imageData
            case .commercial:
                commercialImageView.image = image
                commercialImageData = imageData
            case .notAny:
                break
            }

            picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - LocationDelegate

extension StoreSettingVC: didPickLocationDelegate {
    func finishPickingLocationWith(location: CLLocationCoordinate2D, address: String) {
        locationTf.text = address
        self.location = location
    }

    func failPickingLocation() {
    }
}

// MARK: - API

extension StoreSettingVC {
    func getCategories() {
        showLoader()
        ProviderMoreRouter.getCategories.send(GeneralModel<[Category]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getCategories()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.categoryTf.setupData(data: response.data ?? [])
                    self.categories = response.data ?? []
                    
                    self.categoryTf.selectedPickerData = response.data?.first(where: {$0.slug == self.providerData?.category })
                    self.categoryTf.text = response.data?.first(where: {$0.slug == self.providerData?.category })?.name
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func updateStoreDetails(nameAr: String, nameEn: String, category: String, location: CLLocationCoordinate2D, address: String, bankAccountNumber: String, ibanNumber: String, bankName: String, commirtialID: String, days: String, icon: Data?, cover: Data?, commercialImage: Data?) {
        showLoader()

        var uploadedData = [UploadData]()
        if providerData?.icon?.isEmpty ?? false {
            showError(error: "".localized)
            return
        } else {
            if let icon = icon {
                uploadedData.append(UploadData(data: icon, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "icon"))
            }
        }

        if providerData?.cover?.isEmpty ?? false {
            showError(error: "".localized)
        } else {
            if let cover = cover {
                uploadedData.append(UploadData(data: cover, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "cover"))
            }
        }

        if providerData?.commercialImage?.isEmpty ?? false {
            showError(error: "".localized)
        } else {
            if let commercialImage = commercialImage {
                uploadedData.append(UploadData(data: commercialImage, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "commercial_image"))
            }
        }

        ProviderMoreRouter.updateStoreProfile(nameAr: nameAr, nameEn: nameEn, category: category, location: location, address: address, baankAccountNumber: bankAccountNumber, ibanNumber: ibanNumber, bankName: bankName, commirtialID: commirtialID, days: days).send(GeneralModel<StoreDetailsData>.self, data: uploadedData.isEmpty ? nil : uploadedData) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.updateStoreDetails(nameAr: nameAr, nameEn: nameEn, category: category, location: location, address: address, bankAccountNumber: bankAccountNumber, ibanNumber: ibanNumber, bankName: bankName, commirtialID: commirtialID, days: days, icon: icon, cover: cover, commercialImage: commercialImage)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: response.msg)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}

struct ApiDayModel: Codable {
    let days: String?
    let from: String?
    let to: String?
    init(days: String, from: String, to: String) {
        self.days = days
        self.from = from
        self.to = to
    }
}

extension UIImage {
    func isEqualToImage(_ image: UIImage) -> Bool {
        return pngData() == image.pngData()
    }
}
