//
//  SuccessDeleteBranchVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import BottomPopup
import Lottie
import UIKit

class SuccessDeleteBranchVC: BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?

    override var popupHeight: CGFloat { return height ?? CGFloat(self.view.frame.height) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.4 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.3 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }

    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var backGroungView: UIView!

    var backTapped: (() -> Void)?
    var isDissmess = false

    override func viewDidLoad() {
        super.viewDidLoad()
        popupDelegate = self
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

    @IBAction func uesAction(_ sender: Any) {
        isDissmess = true
        backTapped?()
        dismiss(animated: true)
    }
}

extension SuccessDeleteBranchVC: BottomPopupDelegate {
    func bottomPopupDidDismiss() {
        if isDissmess == false {
            backTapped?()
        }
    }
}
