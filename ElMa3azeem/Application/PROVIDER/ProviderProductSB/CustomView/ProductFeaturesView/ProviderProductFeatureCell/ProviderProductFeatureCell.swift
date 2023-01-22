//
//  ProviderProductFeatureCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/11/2022.
//

import UIKit

class ProviderProductFeatureCell: UITableViewCell {
    @IBOutlet weak var featureLbl: UILabel!
    @IBOutlet weak var FeaturePrice: UILabel!
    @IBOutlet weak var quantiityLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(viewType: ViewType, item: FeatureItem, category: String? = "") {
        featureLbl.text = item.featureTitle
        FeaturePrice.attributedText = item.featurePrice.htmlToAttributedString
        FeaturePrice.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        FeaturePrice.textColor = .appColor(.SecondFontColor)
        switch viewType {
        case .features:
            quantiityLbl.text = item.featureSubTitle
        case .additions:
            quantiityLbl.text = category
        }
    }
}
