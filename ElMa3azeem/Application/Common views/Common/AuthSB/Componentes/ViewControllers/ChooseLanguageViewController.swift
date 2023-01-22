//
//  ChooseLanguageViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 18/11/2022.
//

import UIKit

final class ChooseLanguageViewController: BaseViewController {
//    var presenter: ChooseLanguagePresenter?

    // MARK: - UIViewController Events

    @IBOutlet weak var arabicView: UIView!
    @IBOutlet weak var arbicFlagBg: UIView!
    @IBOutlet weak var englishView: UIView!
    @IBOutlet weak var enlishFlagBg: UIView!

    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var weclomeLbl: UILabel!

    private var intros = [Intro]()
    private var viewControllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // disable
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        getOnBoardingData()
    }

    func setupView() {
        setupLanguageSelected(view: arabicView, flagvVew: arbicFlagBg)
        setupLanguageNotSelected(view: englishView, flagvVew: enlishFlagBg)
        Language.setAppLanguage(lang: Language.Languages.ar)
        weclomeLbl.text = "مرحبا بك"
        infoLbl.text = "من فضلك قم بتحديد اللغة التي تريدها"
        viewTitle.text = "لغة التطبيق"
        confirmBtn.setTitle("تأكيد", for: .normal)
        viewTitle.textAlignment = .right
    }

    @IBAction func chooseArbicAction(_ sender: Any) {
        setupLanguageSelected(view: arabicView, flagvVew: arbicFlagBg)
        setupLanguageNotSelected(view: englishView, flagvVew: enlishFlagBg)
        Language.setAppLanguage(lang: Language.Languages.ar)
        weclomeLbl.text = "مرحبا بك"
        infoLbl.text = "من فضلك قم بتحديد اللغة التي تريدها"
        viewTitle.text = "لغة التطبيق"
        confirmBtn.setTitle("تأكيد", for: .normal)
        viewTitle.textAlignment = .right
    }

    @IBAction func chooseEnglishAction(_ sender: Any) {
        setupLanguageNotSelected(view: arabicView, flagvVew: arbicFlagBg)
        setupLanguageSelected(view: englishView, flagvVew: enlishFlagBg)
        Language.setAppLanguage(lang: Language.Languages.en)
        weclomeLbl.text = "welcome"
        infoLbl.text = "please choose app language"
        viewTitle.text = "app language"
        confirmBtn.setTitle("confirm", for: .normal)
        viewTitle.textAlignment = .left
    }

    @IBAction func cpntinueAction(_ sender: Any) {
        if !viewControllers.isEmpty {
            let VC = PageViewController.create(subViewControllers: viewControllers)
            navigationController?.pushViewController(VC, animated: true)
        }else{
            let vc = AppStoryboards.Auth.instantiate(LoginViewController.self)
            let nav = CustomNavigationController(rootViewController: vc)
            MGHelper.changeWindowRoot(vc: nav)
        }
    }

    func setupLanguageSelected(view: UIView, flagvVew: UIView) {
        view.layer.backgroundColor = UIColor.appColor(.MainColor)?.withAlphaComponent(0.1).cgColor
        view.layer.borderColor = UIColor.appColor(.MainColor)?.cgColor

        flagvVew.layer.cornerRadius = 4
        flagvVew.layer.borderWidth = 1
        flagvVew.layer.borderColor = UIColor.appColor(.MainColor)?.cgColor
    }

    func setupLanguageNotSelected(view: UIView, flagvVew: UIView) {
        view.layer.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3).cgColor
        view.layer.borderColor = UIColor.appColor(.BorderColor)?.cgColor
        flagvVew.layer.backgroundColor = UIColor(hexString: "#F8F8F8").cgColor

        flagvVew.layer.cornerRadius = 4
        flagvVew.layer.borderWidth = 1
        flagvVew.layer.borderColor = UIColor.appColor(.BorderColor)?.cgColor
    }
}

extension ChooseLanguageViewController {
    func getOnBoardingData() {
        showLoader()
        AuthRouter.intro.send(GeneralModel<OnBoardingModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getOnBoardingData()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    if response.data?.intros.isEmpty == false {
                        self.intros = response.data?.intros ?? []
                        self.createViewController(data: self.intros)
                    }
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func createViewController(data: [Intro]) {
        for item in data {
            viewControllers.append(SubViewControllers.createViewController(data: item))
        }
    }
}
