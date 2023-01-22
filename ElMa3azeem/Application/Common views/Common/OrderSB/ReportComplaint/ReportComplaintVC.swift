//
//  ReportComplaintVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 14/01/2022.
//

import UIKit

class ReportComplaintVC: BaseViewController {
    
    @IBOutlet weak var reasoneView: UIView!
    @IBOutlet weak var reasoneTf: AppTextFieldStyle!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var messageView: AppTextFieldViewStyle!
    @IBOutlet weak var noteTv: AppTextViewStyle!

    var orderID = Int()
    var imageArray = [UIImage]()
    var imageArrayData = [Data]()
    var reasonePicker = UIPickerView()
    private var reasonesArray = [ReasonsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getComplainteReasone()
        setupView()
    }
    
    func setupView() {
        setReasonePickerView()
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(UINib(nibName: "ComplaintDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ComplaintDetailsCell")
        imageCollectionView.register(UINib(nibName: "UploadImageIconCell", bundle: nil), forCellWithReuseIdentifier: "UploadImageIconCell")
        
        noteTv.placeHolder = "Please enter complaint details".localized
    }
    
    func setReasonePickerView() {
        reasonePicker.delegate = self
        reasonePicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Choose".localized, style: .done, target: self, action: #selector(self.doneReasoneTapped))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        reasoneTf.inputView = reasonePicker
        reasoneTf.inputAccessoryView = toolBar
        reasoneTf.tintColor = UIColor.clear
    }
    
    func navigateToComplaintSuccessfullyPopup() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue , bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "SuccessfullyViewPopupVC") as! SuccessfullyViewPopupVC
        vc.titleMessage = .CreateCopmlaintSuccess
        vc.backToHome = { [weak self] in
            guard let self = self else{return}
            self.navigationController?.popViewController(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }
    
    @objc func doneReasoneTapped() {
        if reasonesArray.isEmpty == false{
            reasoneTf.text  = reasonesArray[reasonePicker.selectedRow(inComponent: 0)].reason
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func backAction(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        do {
            let reasone = try ValidationService.validate(complainteReasone: reasoneTf.text)
            let reasoneDetails = try ValidationService.validate(complaintDetails: noteTv.text)
            createComlainte(orderID: orderID, subject: reasone , text: reasoneDetails, images: imageArrayData)
        } catch {
            showError(error: error.localizedDescription)
        }
    }
}

//MARK: - Picker Controller Extention
extension ReportComplaintVC : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reasonesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reasonesArray[row].reason
    }
}

//MARK: - CollectionView Extension -
extension ReportComplaintVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageIconCell", for: indexPath) as! UploadImageIconCell
            
//            cell.configerSelectCell(image: UIImage(named: Language.isArabic() ? "upload image icon" : "upload image icon_en")!)
            return cell
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComplaintDetailsCell", for: indexPath) as! ComplaintDetailsCell
            
            if indexPath.row - 1 < imageArray.count {
                cell.configerCell(image: imageArray[indexPath.row - 1], deletable: true)
                
                cell.deleteImage = { [weak self] in
                    guard let self = self else {return}
                    self.imageCollectionView.deleteItems(at: [indexPath])
                    self.imageArray.remove(at: indexPath.row - 1)
                    self.imageArrayData.remove(at: indexPath.row - 1)
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
}

//MARK: - ImagePickerViewController -
extension ReportComplaintVC : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as! UIImage? {
            
            let imageData = image.jpegData(compressionQuality: 0.4)!
            self.imageArrayData.append(imageData)
            imageArray.append(image)
            picker.dismiss(animated: true, completion: nil)
            imageCollectionView.reloadData()
        }
    }
}

//MARK: - API Extention
extension ReportComplaintVC {
    func getComplainteReasone() {
        self.showLoader()
        CreateOrderNetworkRouter.complainteReasones.send(GeneralModel<ReasonsModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getComplainteReasone()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.reasonesArray.append(contentsOf: data.data?.reasons ?? [])
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
    
    func createComlainte(orderID : Int , subject : String , text : String , images : [Data]) {
        self.showLoader()
        
        var uploadedData = [UploadData]()
        images.forEach { image in
            uploadedData.append(UploadData(data: image, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg", name: "images[]"))
        }
        
        CreateOrderNetworkRouter.crateComplainte(orderID: String(orderID), subject: subject, text: text).send(GeneralModel<UserModel>.self,data: uploadedData) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.createComlainte(orderID: orderID, subject: subject, text: text, images: images)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.navigateToComplaintSuccessfullyPopup()
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
}
