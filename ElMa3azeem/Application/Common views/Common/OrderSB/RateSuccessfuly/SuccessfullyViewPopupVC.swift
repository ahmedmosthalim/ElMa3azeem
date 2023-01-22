//
//  RateSuccessfullyVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 05/01/2022.
//

import BottomPopup
import Lottie
import UIKit

class SuccessfullyViewPopupVC: BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?

    override var popupHeight: CGFloat { return height ?? CGFloat(self.view.frame.height) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.4 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.4 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }

    @IBOutlet weak var animationView    : LottieAnimationView!
    @IBOutlet weak var backGroungView   : UIView!
    @IBOutlet weak var titleLbl         : UILabel!
    @IBOutlet weak var subTitleLbl      : UILabel!
    @IBOutlet weak var backBtn          : MainButton!

    var backButtonTitle : SuccessfullyViewPopupButtom = .continu
    var titleMessage    : SuccessfullyViewPopupMessage?
    var subTitleMessage : SuccessfullyViewPopupSubMessage?
    var automaticClose  = true

    var backToHome: (() -> Void)?
    var isDissmess = false

    override func viewDidLoad() {
        super.viewDidLoad()
        popupDelegate = self
        setupView()
        titleLbl.text = titleMessage?.rawValue.localized
        subTitleLbl.text = subTitleMessage?.rawValue.localized
        backBtn.setTitle(backButtonTitle.rawValue.localized, for: .normal)
    }

    func setupView() {
        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
        setupAnimationView()
    }

    func setupAnimationView() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1
        animationView.play(fromProgress: 0,
                           toProgress: 2,
                           loopMode: LottieLoopMode.playOnce)
    }

    @IBAction func backAction(_ sender: Any) {
        isDissmess = true
        dismiss(animated: true)
        backToHome?()
    }
}

extension SuccessfullyViewPopupVC: BottomPopupDelegate {
    func bottomPopupDidDismiss() {
        if automaticClose {
            if isDissmess == false {
                backToHome?()
            }
        }
    }
}
