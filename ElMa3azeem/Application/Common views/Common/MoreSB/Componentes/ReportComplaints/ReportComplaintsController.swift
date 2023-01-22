//
//  ReportComplaintsController.swift
//  ElMa3azeem
//
//  Created by Mohamed Aglan on 1/9/22.
//

import UIKit

class ReportComplaintsController: BaseViewController {

    
    //MARK: - OutLets
    @IBOutlet weak var selectReasonView: UIView!
    @IBOutlet weak var selectReasonTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var addPicturesCollectionView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    //MARK: - Properties
    private var picker = UIPickerView()
    private var imageArray = [UIImage]()
    private var imageArrayData = [Data]()
    
    
    //MARK: - LifeCycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        handlePickerView()
    }
    
    
    
    //MARK: - Logic
    func setUpView() {
        selectReasonView.layer.borderWidth = 0.5
        selectReasonView.layer.borderColor = UIColor.lightGray.cgColor
        selectReasonView.layer.cornerRadius = 8
        descriptionView.layer.borderWidth = 0.5
        descriptionView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionView.layer.cornerRadius = 8
        sendButton.layer.cornerRadius = 8
    }
    
    func handlePickerView() {
        picker.delegate = self
        picker.dataSource = self
        selectReasonTextField.inputView = picker
    }
    
    
    func handleCollectionViewCell() {
        addPicturesCollectionView.delegate = self
        addPicturesCollectionView.dataSource = self
        addPicturesCollectionView.register(UINib(nibName: "ComplaintDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ComplaintDetailsCell")
        addPicturesCollectionView.register(UINib(nibName: "UploadImageIconCell", bundle: nil), forCellWithReuseIdentifier: "UploadImageIconCell")
    }
    
    
    //MARK: - Networking
    
    
    
    
    //MARK: - Actions
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
    }
    

}


//MARK: - Extensions

// Image Picker

//extension ReportComplaintsController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.originalImage] as! UIImage? {
//            let imageData = image.jpegData(compressionQuality: 0.4)!
//            self.imageData = imageData
//            userImage.image = image
//            updateImage = true
//            picker.dismiss(animated: true, completion: nil)
//        }
//    }
//}

// PickerViewController

extension ReportComplaintsController : UIPickerViewDelegate , UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
//    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return self.getPickerNameAt(index: row)
//    }

//    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        codeLbl.text = getPickerNameAt(index: row)
//        self.flagImage.setImage(image: getPickerFlagAt(index: row) ?? "")
//        self.selectedNationalityId(index: row)
//        codeLbl.resignFirstResponder()
//    }
}




//MARK: - CollectionView Extension -
extension ReportComplaintsController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageIconCell", for: indexPath) as! UploadImageIconCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComplaintDetailsCell", for: indexPath) as! ComplaintDetailsCell

            if indexPath.row - 1 < imageArray.count {
                cell.configerCell(image: imageArray[indexPath.row - 1], deletable: true)

                cell.deleteImage = { [weak self] in
                    guard let self = self else { return }
                    self.addPicturesCollectionView.deleteItems(at: [indexPath])
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


