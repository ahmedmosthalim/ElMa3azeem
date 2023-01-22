//
//  AdsCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 27/11/2022.
//

import UIKit
import PageControls
 

class AdsCell: UITableViewCell , HomeSliderCellView{
    
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: SnakePageControl!
    
    private var selectedSliderIndex: IndexPath = IndexPath(item: 0, section: 0)
    private weak var timer: Timer?
    private var counter = 0
    
    var ads = [Ad]()
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        setupSlider()
        pageControl.transform = Language.isArabic() ? CGAffineTransform(scaleX: -1.0, y: 1.0) : CGAffineTransform.identity
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImageSliderCell", bundle: nil), forCellWithReuseIdentifier: "ImageSliderCell")
    }
    
    func configureAdsSlider(model: [Ad]) {
        self.ads = model
        self.pageControl.pageCount = ads.count
        collectionView.reloadData()
    }
    
    func configureImageSlider(cell: ImageSliderCellView, forRow row: Int) {
        cell.setImage(url: ads[row].cover ?? "")
        cell.setIcon(url: ads[row].image ?? "")
        cell.setTitle(name: ads[row].title ?? "")
        cell.setDescription(desc: ads[row].content ?? "")
    }
    
    func setupSlider() {
        pageControl.pageCount = ads.count
        pageControl.progress = CGFloat(counter)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeImage() {
        
        if counter < ads.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.progress = CGFloat(counter)
            counter += 1
            return
        }
        
        counter = 0
        let index = IndexPath.init(item: counter, section: 0)
        self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        pageControl.progress = CGFloat(counter)
        counter = 1
        
    }
}

//MARK: - CollectionView Extension -
extension AdsCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSliderCell", for: indexPath) as! ImageSliderCell
        configureImageSlider(cell: cell, forRow: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            var visibleRect = CGRect()
            
            visibleRect.origin = self.collectionView.contentOffset
            visibleRect.size = self.collectionView.bounds.size
            
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            
            guard let indexPath = self.collectionView.indexPathForItem(at: visiblePoint) else { return }
            
            self.counter = indexPath.item
            self.pageControl.progress = CGFloat(counter)
        }
    }
}

extension AdsCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.bounds.width)
        let progress = CGFloat(page) + progressInPage
        pageControl.progress = progress
    }
}
