//
//  SingleStoresCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2111/2022.
//

import UIKit

class SingleStoresCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellStoreName: UILabel!
    @IBOutlet weak var cellAddress: UILabel!
    @IBOutlet weak var cellRate: UILabel!
    @IBOutlet weak var cellRateView: StarRatingView!
    @IBOutlet weak var rateView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configeCell(store: Store?, isStoreDetails: Bool? = false) {
        cellImage.setImage(image: store?.icon ?? "", loading: true)
        cellStoreName.text = store?.name
        cellAddress.text = store?.address
        cellRate.text = store?.rate
        cellRateView.rating = store?.rate?.floatValue ?? 0.0
    }
}
