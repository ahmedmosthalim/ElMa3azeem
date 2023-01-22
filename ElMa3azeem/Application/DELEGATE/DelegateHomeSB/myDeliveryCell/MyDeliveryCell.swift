//
//  MyDeliveryCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/01/2022.
//

import UIKit

class MyDeliveryCell: UITableViewCell {
    
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    
    @IBOutlet weak var orderStoreNameTitle: UILabel!
    @IBOutlet weak var reciveDistance: UILabel!
    @IBOutlet weak var deliveryDistance: UILabel!

    @IBOutlet weak var locationStackView: UIStackView!
    @IBOutlet weak var recivingLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configeCell(order : DelegateOrder) {
        
        orderImage.setImage(image: order.image, loading: true)
        orderNumber.text = "\(order.id)"
        orderName.text = order.name
        reciveDistance.text = order.distanceToReceiveAddress
        deliveryDistance.text = order.distanceToDeliverAddress
        orderTime.text = order.createdAt
        orderStoreNameTitle.text = "store name :".localized
//        switch order.orderType {
//        case OrderType.specialStoreWithDelivery:
//            orderStoreNameTitle.text = "store name :".localized
//        case OrderType.googleStore:
//            orderStoreNameTitle.text = "store name :".localized
//        case OrderType.parcelDelivery , OrderType.specialPackage :
//            orderStoreNameTitle.text = "customer name :".localized
//        default:
//            break
//        }
    }
}
