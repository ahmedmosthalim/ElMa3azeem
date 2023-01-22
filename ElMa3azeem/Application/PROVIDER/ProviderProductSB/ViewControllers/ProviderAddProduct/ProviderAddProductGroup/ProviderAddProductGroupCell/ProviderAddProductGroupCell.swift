//
//  ProviderAddProductGroupCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import UIKit

class ProviderAddProductGroupCell: UITableViewCell {
    // outlets

    @IBOutlet weak var deleteButton         : UIView!
    @IBOutlet weak var priceTf              : AppTextFieldStyle!
    @IBOutlet weak var quantityTf           : AppTextFieldStyle!
    @IBOutlet weak var discountTf           : AppTextFieldStyle!
    @IBOutlet weak var fromDateTf           : AppPickerTextFieldStyle!
    @IBOutlet weak var toDateTf             : AppPickerTextFieldStyle!
    @IBOutlet weak var groupCollectionView  : CustomCollectionView!

    var selectedFeatureID = Int()
    var screenReasone: ScreenReason = .addNew
    let screenSize: CGRect = UIScreen.main.bounds
    var featureData = [Feature]()
    var selectedGroup : Group?

    var selectFeature: ((Feature) -> Void)?
    var updatePrice: ((String) -> Void)?
    var updateStock: ((String) -> Void)?
    var updateDiscountPrice: ((String) -> Void)?
    var updateFromDate: ((Date) -> Void)?
    var updateToDate: ((Date) -> Void)?
    var deleteGroupTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
        collectionViewConfigration()
    }

    func configView() {
        fromDateTf.pickerType    = .date
        toDateTf.pickerType     = .date

        priceTf.addTarget(self, action: #selector(updatePriceTapped), for: .editingDidEnd)
        quantityTf.addTarget(self, action: #selector(updateStockTapped), for: .editingDidEnd)
        fromDateTf.addTarget(self, action: #selector(updateFromDateTapped), for: .editingDidEnd)
        toDateTf.addTarget(self, action: #selector(updateToDateTapped), for: .editingDidEnd)
        discountTf.addTarget(self, action: #selector(updateDiscountPriceTapped), for: .editingDidEnd)
    }

    @objc func updatePriceTapped() {
        updatePrice?(priceTf.text ?? "")
    }

    @objc func updateStockTapped() {
        updateStock?(quantityTf.text ?? "")
    }

    @objc func updateDiscountPriceTapped() {
        updateDiscountPrice?(discountTf.text ?? "")
    }

    @objc func updateFromDateTapped() {
        updateFromDate?(fromDateTf.selectedDate)
    }

    @objc func updateToDateTapped() {
        updateToDate?(toDateTf.selectedDate)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        featureData = []
        quantityTf.text = nil
        priceTf.text = nil
        discountTf.text = nil
        fromDateTf.text = nil
        toDateTf.text = nil
    }

    // MARK: - CONFIGRATION

    private func collectionViewConfigration() {
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        groupCollectionView.register(UINib(nibName: "ProviderAddProductSingleGroupCell", bundle: nil), forCellWithReuseIdentifier: "ProviderAddProductSingleGroupCell")
    }

    func configCell(group: AddProductGroupModel? ,screenReasone: ScreenReason) {
        featureData = group?.features ?? []
        priceTf.text = group?.price ?? ""
        quantityTf.text = group?.qty ?? ""
        fromDateTf.selectedDate = group?.from ?? Date()
        toDateTf.selectedDate = group?.to ?? Date()
        discountTf.text = group?.discountPrice ?? ""
        fromDateTf.text = fromDateTf.selectedDate.dateToString
        toDateTf.text = toDateTf.selectedDate.dateToString
//        self.selectedGroup = selectedGroup
        self.screenReasone = screenReasone

        groupCollectionView.reloadData()
        groupCollectionView.layoutIfNeeded()
    }

    @IBAction func deleteAction(_ sender: Any) {
        deleteGroupTapped?()
    }
}

// MARK: - CollectionView Extension

extension ProviderAddProductGroupCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featureData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProviderAddProductSingleGroupCell", for: indexPath) as! ProviderAddProductSingleGroupCell
        
        cell.configPropertyCell(screenReasone: screenReasone, feature: featureData[indexPath.row], group: selectedGroup)

        cell.updateProperty = { [weak self] properity in
            guard let self = self else { return }
            self.featureData[indexPath.row].selectedProperity = properity
            self.selectFeature?(self.featureData[indexPath.row])
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewSize = collectionView.frame.width / 2
        return CGSize(width: collectionViewSize, height: 90)
    }
}
