//
//  AboutUsViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import UIKit
import SwiftUI
import PageControls

final class AboutUsViewController: BaseViewController {
    
    var presenter: AboutUsPresenter?
    
    // MARK: - UIViewController Events
    
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var pageControl: SnakePageControl!
    @IBOutlet weak var intoCollectionView: UICollectionView!
    @IBOutlet weak var contenueBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupView()
        self.tabBarController?.hideTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        pageLeftConst.constant = UIScreen.main.bounds.width / 2 + 20
    }
    
    func setupView() {
        
        pageControl.semanticContentAttribute = .forceLeftToRight
        
        intoCollectionView.delegate = self
        intoCollectionView.dataSource = self
        intoCollectionView.register(UINib(nibName: "OnBoardingCell", bundle: nil), forCellWithReuseIdentifier: "OnBoardingCell")
        
        collectionView.layer.masksToBounds = true
        collectionView.layer.cornerRadius = 40
        collectionView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        didPressNext()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension AboutUsViewController: AboutUsView {
    func setNumberOfPages() {
        self.pageControl.pageCount = presenter?.itemsCount() ?? 0
    }
    
    func fetchingDataSuccess() {
        self.intoCollectionView.reloadData()
    }
    
    func didPressNext() {
        
        if pageControl.currentPage == (presenter?.itemsCount() ?? 0) - 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            let collectionBounds = self.intoCollectionView.bounds
            let contentOffset = CGFloat(floor(self.intoCollectionView.contentOffset.x + collectionBounds.size.width))
            self.moveCollectionToFrame(contentOffset: contentOffset)
        }
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        
        let frame: CGRect = CGRect(x : contentOffset ,y : self.intoCollectionView.contentOffset.y ,width : self.intoCollectionView.frame.width,height : self.intoCollectionView.frame.height)
        self.intoCollectionView.scrollRectToVisible(frame, animated: true)
    }
}

//MARK: - CollectionView Extension -
extension AboutUsViewController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.itemsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCell", for: indexPath) as! OnBoardingCell
        
        if indexPath.row == (presenter?.itemsCount() ?? 0) - 1 {
            contenueBtn.setTitle("continue your experience now".localized, for: .normal)
        }
        
        presenter?.configure(cell: cell, forRow: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension AboutUsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.width)
        let progress = CGFloat(page) + progressInPage
        pageControl.progress = progress
    }
}
