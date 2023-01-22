//
//  MyDeliverySpecislCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/01/2022.
//

import UIKit

class MyDeliverySpecislCell: UITableViewCell {

    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var orderState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configeCell(order : DelegateOrder) {
        orderImage.setImage(image: order.image, loading: true)
        orderNumber.text = "\(order.id)"
        orderName.text = order.userName
        orderTime.text = order.createdAt
        orderState.text = order.status.localized
    }
}
