//
//  ProviderFinanceCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 21/11/2022.
//

import UIKit

class ProviderFinanceCell: UITableViewCell {
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var orderPriceLbl: UILabel!
    @IBOutlet weak var commissionLbl: UILabel!
    @IBOutlet weak var addedValueLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configCell(model: StoreFinanceModel) {
        orderNumberLbl.text = String(model.orderID)
        timeLbl.text = model.createdAt
        orderPriceLbl.text = String(model.price).addAppCurrency
        commissionLbl.text = model.appPercentage.addAppCurrency
        addedValueLbl.text = model.addedValue.addAppCurrency
        totalPriceLbl.text = model.totalPrice.addAppCurrency
    }
}
