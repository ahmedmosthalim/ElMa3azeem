//
//  ChooseLanguagePresenter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 18/11/2022.
//

import Foundation

protocol ChangeLanguageView: BaseView {
    func selectArbic()
    func selectEnglish()
}


protocol ChangeLanguagePresenter {
    func viewDidLoad()
    func didPressContenue(selectedLanguage : String)
}

class ChangeLanguagePresenterImplementation: ChangeLanguagePresenter {
    fileprivate weak var view: ChangeLanguageView?
    internal let router: ChangeLanguageRouter
    internal let interactor : ChangeLanguageInteractor

    
    init(view: ChangeLanguageView,router: ChangeLanguageRouter,interactor:ChangeLanguageInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        if Language.isArabic() {
            self.view?.selectArbic()
        }else{
            self.view?.selectEnglish()
        }
    }
    
    func didPressContenue(selectedLanguage : String) {
        if Language.isArabic() {
            Language.setAppLanguage(lang: Language.Languages.ar)
        }else{
            Language.setAppLanguage(lang: Language.Languages.en)
        }
    }
}
