//
//  OnBoardingViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import UIKit
//import SwiftUI
import PageControls

final class OnBoardingViewController: BaseViewController {
    
    //    var presenter: OnBoardingPresenter?
    
    // MARK: - UIViewController Events
    
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var pageControl: SnakePageControl!
    @IBOutlet weak var intoCollectionView: UICollectionView!
    @IBOutlet weak var contenueBtn: UIButton!
        
    var intros = [Intro]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getOnBoardingData()
        setupView()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    
    
    func setupView() {
        pageControl.contentMode = .center
        pageControl.semanticContentAttribute = .forceLeftToRight
        intoCollectionView.delegate = self
        intoCollectionView.dataSource = self
        intoCollectionView.register(UINib(nibName: "OnBoardingCell", bundle: nil), forCellWithReuseIdentifier: "OnBoardingCell")
        collectionView.layer.masksToBounds = true
        collectionView.layer.cornerRadius = 40
        collectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    func navigateToChooseLoginType() {
        let vc = AppStoryboards.Auth.instantiate(ChooseLoginType.self)
        let nav = CustomNavigationController(rootViewController: vc)
        MGHelper.changeWindowRoot(vc: nav)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.didPressNext()
    }
    
    @IBAction func skipAction(_ sender: Any) {
        navigateToChooseLoginType()
    }
}


extension OnBoardingViewController {
    func setNumberOfPages() {
        self.pageControl.pageCount = intros.count
    }
    
    func fetchingDataSuccess() {
        self.intoCollectionView.reloadData()
    }
    
    func didPressNext() {
        if pageControl.currentPage == intros.count - 1 {
            navigateToChooseLoginType()
        } else {
            let collectionBounds = self.intoCollectionView.bounds
            let contentOffset = CGFloat(floor(self.intoCollectionView.contentOffset.x + collectionBounds.size.width))
            self.moveCollectionToFrame(contentOffset: contentOffset)
        }
    }
    
    
    func navigateToLogin() {
        defult.shared.setData(data: false, forKey: .isFiristLuanch)
        let storyboard = UIStoryboard(name: StoryBoard.Auth.rawValue , bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ChooseLoginType") as! ChooseLoginType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.intoCollectionView.contentOffset.y ,width : self.intoCollectionView.frame.width,height : self.intoCollectionView.frame.height)
        self.intoCollectionView.scrollRectToVisible(frame, animated: true)
    }
}

//MARK: - CollectionView Extension -
extension OnBoardingViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return intros.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCell", for: indexPath) as! OnBoardingCell
        
        if indexPath.row == intros.count - 1 {
            contenueBtn.setTitle("start your experience now".localized, for: .normal)
        }
        
        let item = self.intros[indexPath.row]
        cell.setCellImage(url: item.image)
        cell.setCellTitle(title: item.title)
        cell.setCellDescirotion(text: item.desc)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension OnBoardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.width)
        let progress = CGFloat(page) + progressInPage
        pageControl.progress = progress
    }
}



extension OnBoardingViewController {
    func getOnBoardingData() {
        self.showLoader()
        AuthRouter.intro.send(GeneralModel<OnBoardingModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getOnBoardingData()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let response):
                if response.key == ResponceStatus.success.rawValue {
                    self.intros = response.data?.intros ?? []
                    self.intoCollectionView.reloadData()
                    self.pageControl.pageCount = self.intros.count
                }else{
                    self.showError(error: response.msg)
                }
            }
        }
    }
}
