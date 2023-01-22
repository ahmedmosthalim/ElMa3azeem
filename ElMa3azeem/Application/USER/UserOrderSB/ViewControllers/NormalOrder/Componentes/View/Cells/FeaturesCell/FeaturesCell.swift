//
//  FeaturesCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1411/2022.
//

import UIKit

protocol selectFeatureProtocol{
    func selectFeature(feature : Feature?)
}


class FeaturesCell: UITableViewCell {

    @IBOutlet weak var featureLbl: UILabel!
    @IBOutlet weak var featureCollectionView: UICollectionView!
    
    var selectedProprityId = Int()
    var features : Feature?
    var delegate : selectFeatureProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView() {
//        featureCollectionView.semanticContentAttribute = .forceRightToLeft
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        featureCollectionView.register(UINib(nibName: "OneFeatureCell", bundle: nil), forCellWithReuseIdentifier: "OneFeatureCell")
    }
    
    func configCell (data : Feature) {
        self.featureLbl.text = data.name
        self.features = data
        featureCollectionView.reloadData()
    }
}

//MARK: - CollectionView Extension -
extension FeaturesCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return features?.properities?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OneFeatureCell", for: indexPath) as! OneFeatureCell
        cell.configCell(feature: features?.properities?[indexPath.row], current: selectedProprityId)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedProprityId = features?.properities?[indexPath.row].id ?? 0
        
        features?.properities?.enumerated().forEach({ (index , item) in
            if selectedProprityId ==  features?.properities?[index].id{
                features?.properities?[index].isSelected = true
            }else{
                features?.properities?[index].isSelected = false
            }
        })
        
        featureCollectionView.reloadData()
        delegate?.selectFeature(feature: features)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((features?.properities?[indexPath.row].name?.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width)!) + 52, height: 40)
    }
}
