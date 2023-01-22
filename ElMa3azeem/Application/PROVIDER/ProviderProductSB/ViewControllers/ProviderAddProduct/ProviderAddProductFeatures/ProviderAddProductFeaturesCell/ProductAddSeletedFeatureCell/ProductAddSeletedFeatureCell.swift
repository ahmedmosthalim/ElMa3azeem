//
//  ProductAddSeletedFeatureCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 24/11/2022.
//

import UIKit

class ProductAddSeletedFeatureCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var featureTitle: UILabel!
    @IBOutlet weak var featureTf: AppPickerTextFieldStyle!
    @IBOutlet weak var seletcPropertyLbl: UILabel!

    var propertyArray = [Properity]()
    var selectedPropertyArray = [Properity]()
    var deleteTapped: (() -> Void)?
    var addError: ((String) -> Void)?

    var addProperty: ((Properity) -> Void)?
    var removeProperty: ((Properity) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewConfigration()
        featureTf.addTarget(self, action: #selector(updateFeature), for: .editingDidEnd)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @objc func updateFeature() {
        let index = featureTf.currentIndex
        addProperty(index: index)
        collectionView.reloadData()
    }

    private func collectionViewConfigration() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProductAddSeletedSingleFeatureCell", bundle: nil), forCellWithReuseIdentifier: "ProductAddSeletedSingleFeatureCell")
    }

    func configCell(item: AppFeatureModel) {
        featureTitle.text = item.name

        seletcPropertyLbl.attributedText = "\("selet".localized) \(item.name ?? "")".isRequired(fontSize: 14, fontName: .Demi)

        featureTf.setupData(data: item.properties ?? [])
        propertyArray = item.properties ?? []
        selectedPropertyArray = item.properties?.filter({ $0.isSelected == true }) ?? []
        collectionView.isHidden = selectedPropertyArray.isEmpty
        collectionView.reloadData()
    }

    func addProperty(index: Int) {
        if propertyArray[index].isSelected == false {
            addProperty?(propertyArray[index])
        } else {
            addError?("The selected property added before".localized)
        }

        featureTf.selectedPickerData = nil
        featureTf.text = ""
    }

    func removeProperty(index: Int) {
        removeProperty?(selectedPropertyArray[index])
    }

    @IBAction func deleteFeatureAction(_ sender: Any) {
        deleteTapped?()
    }
}

// MARK: - CollectionView Extension

extension ProductAddSeletedFeatureCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPropertyArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductAddSeletedSingleFeatureCell", for: indexPath) as! ProductAddSeletedSingleFeatureCell
        cell.configCell(item: selectedPropertyArray[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        removeProperty(index: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (propertyArray[indexPath.row].name?.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]).width)! + 80, height: collectionView.bounds.height)
    }
}
