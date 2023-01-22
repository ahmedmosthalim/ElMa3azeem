//
//  ChooseLanguageViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 18/11/2022.
//

import BottomPopup
import NVActivityIndicatorView
import UIKit

final class ChangeLanguageViewController: BottomPopupViewController {
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

    var presenter: ChangeLanguagePresenter?

    // MARK: - UIViewController Events

    @IBOutlet weak var arabicView: UIView!
    @IBOutlet weak var englishView: UIView!

    @IBOutlet weak var arabicImage: UIImageView!
    @IBOutlet weak var englisImage: UIImageView!

    var langauge = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        tabBarController?.hideTabbar()

        setupArabicViewTapped()
        setupEnglishViewTapped()
    }

    private func setupArabicViewTapped() {
        arabicView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.langauge = appLanguage.arabic.rawValue
            self.selectArbic()
        }
    }

    private func setupEnglishViewTapped() {
        englishView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.langauge = appLanguage.english.rawValue
            self.selectEnglish()
        }
    }

    @IBAction func continueAction(_ sender: Any) {
        if langauge != "" {
            presenter?.didPressContenue(selectedLanguage: langauge)
            changeLanguageDirection()
        } else {
            showError(error: "Please choose a new language first.".localized)
        }
    }

    func setupLanguageSelected(view: UIView, image: UIImageView) {
        view.backgroundColor = UIColor.appColor(.MainColor)?.withAlphaComponent(0.20)
        view.layer.borderColor = UIColor.appColor(.MainColor)?.cgColor
        view.layer.borderWidth = 1
        image.image = UIImage(named: "circle-mark-selected")
    }

    func setupLanguageNotSelected(view: UIView, image: UIImageView) {
        view.backgroundColor = .appColor(.BackGroundCell)?.withAlphaComponent(0.40)
        view.layer.borderWidth = 0
        image.image = UIImage(named: "circle-mark-not-selected")
    }

    func changeLanguageDirection() {
        Language.setAppLanguage(lang: langauge)
        guard let _ = defult.shared.user()?.user?.accountType else {
            guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
            var sb = UIStoryboard()
            sb = UIStoryboard(name: StoryBoard.Home.rawValue, bundle: nil)
            let mainTabBarController = sb.instantiateViewController(identifier: "CustomTabBarController")
            window.rootViewController = mainTabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)

            return
        }
        RestartToHome()
    }
}

extension ChangeLanguageViewController: ChangeLanguageView {
    func selectArbic() {
        setupLanguageSelected(view: arabicView, image: arabicImage)
        setupLanguageNotSelected(view: englishView, image: englisImage)
    }

    func selectEnglish() {
        setupLanguageNotSelected(view: arabicView, image: arabicImage)
        setupLanguageSelected(view: englishView, image: englisImage)
    }
}
