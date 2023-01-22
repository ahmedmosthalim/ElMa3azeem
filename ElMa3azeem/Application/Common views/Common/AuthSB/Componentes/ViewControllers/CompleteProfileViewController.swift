//
//  CompleteProfileViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 24/11/2022.
//

import TransitionButton
import UIKit

final class CompleteProfileViewController: BaseViewController {
//    var presenter: CompleteProfilePresenter?

    // MARK: - UIViewController Events

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var userNameTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var mailTf: UITextField!
    @IBOutlet weak var confirmBtn: TransitionButton!

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var codeLbl: UILabel!

    private var ImageData: Data?
    private var isSelectImage = false

    var token = String()
    var phone: String?
    var country: Country?
    var termsAreAgreed : Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let country = country {
            setupView(phone: phone ?? "", contry: country)
        }
        setuupView()
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func setuupView() {
        phoneView.semanticContentAttribute = .forceLeftToRight
        phoneTf.textAlignment = .left
        checkImage.addTapGesture {
            self.termsAreAgreed.toggle()
            self.checkImage.image = self.termsAreAgreed ? UIImage(named: "squar_check_mark_selected") :  UIImage(named: "squar_check_mark_not_selected")
        }
    }

    @IBAction func chooseImageAction(_ sender: Any) {
        uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }

    @IBAction func confirmAction(_ sender: Any) {
        do {
            let name = try ValidationService.validate(name: userNameTf.text ?? "")
            let email = try ValidationService.validateEmail(mailTf.text ?? "")
            animationButton()
            completeData(email: email, name: name, phone: phone ?? "", token: token)
//            if self.termsAreAgreed == true
//            {
//            }else
//            {
//                showError(error: "Please Agree Terms and Conditions To Complete".localized)
//            }
        } catch {
            showError(error: error.localizedDescription)
        }
    }
}

extension CompleteProfileViewController {
    func failComplete(message: String) {
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            DispatchQueue.main.async(execute: { () -> Void in
                self.confirmBtn.stopAnimation(animationStyle: .shake, completion: {
                    self.showError(error: message)
                })
            })
        })
    }

    func successComlete() {
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            DispatchQueue.main.async(execute: { () -> Void in
                self.confirmBtn.stopAnimation(animationStyle: .expand, completion: {
                    RestartToHome()
                })
            })
        })
    }

    func animationButton() {
        confirmBtn.startAnimation()
    }

    func setupView(phone: String, contry: Country) {
        flagImage.setImage(image: contry.flag)
        codeLbl.text = contry.callingCode
        phoneTf.text = phone
        userImage.setImage(image: defult.shared.user()?.user?.avatar ?? "", loading: true)
    }
}

// MARK: - ImagePickerViewController -

extension CompleteProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as! UIImage? {
            let imageData = image.jpegData(compressionQuality: 0.4)!
            ImageData = imageData
            isSelectImage = true
            userImage.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension CompleteProfileViewController {
    func completeData(email: String, name: String, phone: String, token: String) {
        showLoader()
        var uploadedData = [UploadData]()

        if isSelectImage == true {
            uploadedData.append(UploadData(data: ImageData ?? Data(), fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png", name: "edit_avatar"))
        }

        AuthRouter.completeInto(email: email, name: name, phone: phone, token: token).send(GeneralModel<UserModel>.self, data: uploadedData) { [weak self] result in
            self?.hideLoader()
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.completeData(email: self?.mailTf.text! ?? "", name: self?.userNameTf.text! ?? "", phone: phone, token: token)
                    }
                } else {
                    self.failComplete(message: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    if response.key == ResponceStatus.success.rawValue {
                        defult.shared.setData(data: self.token, forKey: .token)
                        defult.shared.saveUser(user: response.data)
                        self.successComlete()
                    } else {
                        self.failComplete(message: response.msg)
                    }
                } else {
                    self.failComplete(message: response.msg)
                }
            }
        }
    }
}
