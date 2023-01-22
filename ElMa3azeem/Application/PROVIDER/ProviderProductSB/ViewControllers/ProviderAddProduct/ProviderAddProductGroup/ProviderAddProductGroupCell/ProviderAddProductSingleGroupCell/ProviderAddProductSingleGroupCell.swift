//
//  ProviderAddProductSingleGroupCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import UIKit

class ProviderAddProductSingleGroupCell: UICollectionViewCell {
    @IBOutlet weak var featureTitleLbl: UILabel!
    @IBOutlet weak var propertyTf: AppPickerTextFieldStyle!
    var updateProperty: ((Properity) -> Void)?
    var feature = [Properity]()

    override func awakeFromNib() {
        super.awakeFromNib()
        propertyTf.addTarget(self, action: #selector(updatePropertyAction), for: .editingDidEnd)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        featureTitleLbl.text = ""
        propertyTf.text = ""
        propertyTf.selectedPickerData = nil
        feature = []
    }

    @objc func updatePropertyAction() {
        updateProperty?(feature[propertyTf.currentIndex])
    }

    func configPropertyCell(screenReasone: ScreenReason, feature: Feature?, group: Group?) {
        featureTitleLbl.attributedText = feature?.name?.isRequired(fontSize: 14, fontName: .Demi)
        self.feature = feature?.properities ?? []
        propertyTf.setupData(data: feature?.properities ?? [])
        propertyTf.text = feature?.selectedProperity?.name
//        switch screenReasone {
//        case .addNew:
//            propertyTf.text = feature?.selectedProperity?.name
//        case .edit:
//            group?.propreties?.forEach({ propirty in
//                let index = feature?.properities?.firstIndex(where: { $0.id == propirty.id }) ?? 0
//                print(index)
//                propertyTf.currentIndex = index
//                propertyTf.text = feature?.selectedProperity?.name != nil ? feature?.selectedProperity?.name : feature?.properities?[index].name
//                updateProperty?((feature?.properities?[propertyTf.currentIndex])!)
//            })
//        }

        
    }
}
