//
//  SuccessAddOrderPopupVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2111/2022.
//

import BottomPopup
import Lottie
import UIKit

class SuccessAddOrderPopupVC: BottomPopupViewController {
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
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var backGroungView: UIView!
    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!

    @IBOutlet weak var continueBtn: UIButton!
    var backToHome: (() -> Void)?
    var trackOrder: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        bottomStack.semanticContentAttribute = Language.isArabic() ? .forceRightToLeft : .forceLeftToRight
        continueBtn.setImage(Language.isArabic() ? UIImage(systemName: "arrow.left") : UIImage(systemName: "arrow.right"), for: .normal)

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

    @IBAction func continueAction(_ sender: Any) {
        dismiss(animated: true)
        trackOrder?()
    }

    @IBAction func backHomeAction(_ sender: Any) {
        dismiss(animated: true)
        backToHome?()
    }
}
