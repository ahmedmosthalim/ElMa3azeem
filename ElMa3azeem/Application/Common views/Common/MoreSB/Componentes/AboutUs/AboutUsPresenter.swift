//
//  AboutUsPresenter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation

protocol AboutUsView: BaseView {
    func fetchingDataSuccess()
    func setNumberOfPages()
    func didPressNext()
}

protocol AboutUsPresenter {
    func viewDidLoad()
    func getAboutUsData()
    func itemsCount() -> Int
    func didPressContinue()
    func didPressStast()
    func configure(cell: OnBoardingCell, forRow row: Int)
}

class AboutUsPresenterImplementation: AboutUsPresenter {
    
    fileprivate weak var view: AboutUsView?
    internal let router: AboutUsRouter
    internal let interactor : AboutUsInteractor
    
    var intros = [Intro]()
    private var selectedIndex: Int = 0
    
    init(view: AboutUsView,router: AboutUsRouter,interactor:AboutUsInteractor) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        getAboutUsData()
    }
    
    func didPressStast() {
        router.navigateToLogin()
    }
    
    func itemsCount() -> Int {
        return intros.count
    }
    
    func didPressContinue() {
        self.view?.didPressNext()
    }
    
    func configure(cell: OnBoardingCell, forRow row: Int) {
        let item = intros[row]
        cell.setCellImage(url: item.image)
        cell.setCellTitle(title: item.title)
        cell.setCellDescirotion(text: item.desc)
    }
    
    func getAboutUsData() {
        self.view?.showLoader()
        interactor.getIntro { [weak self] data, error in
            self?.view?.hideLoader()
            guard let self = self else {return}
            self.view?.hideLoader()
            if let error = error{
                self.view?.showError(error: error.localizedDescription)
            }else{
                guard let data = data else {return}
                if data.key == ResponceStatus.success.rawValue {
                    self.intros = data.data?.intros ?? []
                    self.view?.fetchingDataSuccess()
                    self.view?.setNumberOfPages()
                }else{
                    self.view?.showError(error: data.msg ?? "")
                }
            }
        }
    }
}
