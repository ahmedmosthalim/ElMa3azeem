//
//  MostPopularStoreCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//  Copyright © 2022 Abdullah Tarek & Ahmed Mostafa Halim. All rights reserved.
//

import UIKit
 

class MostPopularStoreCell: UITableViewCell , HomeStoreCellView {

    @IBOutlet weak var MostPopularStoreCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewHight: NSLayoutConstraint!
        
    weak var delegate : selectCategoryProtocol?
    
    var size = 0
    var type = ""
    var numberOfItem = 0
    var stores = [Store]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureStoreCell(model: [Store],  size : String , type:String , rows : String) {
        
        self.type = type
        self.stores = model
        self.size = Int(size) ?? 0
        self.numberOfItem = Int(rows) ?? 0
        MostPopularStoreCollectionView.reloadData()
        
        if type == "horizontal" {
            collectionViewHight.constant = 100
            if let layout = MostPopularStoreCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
        }else{
            collectionViewHight.constant = CGFloat(model.count * 100)
            if let layout = MostPopularStoreCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
            }
        }
    }
    
    func setupView() {
        MostPopularStoreCollectionView.delegate = self
        MostPopularStoreCollectionView.dataSource = self
        MostPopularStoreCollectionView.register(UINib(nibName: "HomeStoreCell", bundle: nil), forCellWithReuseIdentifier: "HomeStoreCell")
    }
    
    func StoreSliderCellView(cell: StoreSliderCellView, forRow row: Int) {
        cell.setImage(url: stores[row].icon ?? "")
        cell.setStoreName(name: stores[row].name ?? "")
        cell.setStoreCategory(category: stores[row].categoryName ?? "")
        cell.setRate(rate : stores[row].rate ?? "")
        cell.setDistance(dist : stores[row].distance ?? "")
        cell.storeState(state : stores[row].isOpen ?? false)
    }
    
}

extension MostPopularStoreCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stores.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeStoreCell", for: indexPath) as! HomeStoreCell
        StoreSliderCellView(cell: cell, forRow: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.selectStoreFromHome(index: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Int((collectionView.frame.width * Double(size))) / 100) / numberOfItem, height: 90)
    }
}
