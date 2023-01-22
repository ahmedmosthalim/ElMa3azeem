//
//  OrderCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2611/2022.
//

import UIKit

class OrderCell: UITableViewCell {
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderState: UILabel!
    @IBOutlet weak var orderTime: UILabel!
    @IBOutlet weak var storeNameLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configeCell(order: Order) {
        orderImage.setImage(image: order.image, loading: true)
        orderNumber.text = "\(order.id)"
        orderName.text = order.name

        guard let accountType = defult.shared.user()?.user?.accountType else { return }
        switch accountType {
        case .user ,.delegate:
            storeNameLbl.text = "store name :".localized
        case .provider:
            storeNameLbl.text = "customer name :".localized
        case .unknown:
            break
        }
//        switch order.orderType {
//        case OrderType.specialStoreWithDelivery:
//            storeNameLbl.text = "family name :".localized
//        case OrderType.googleStore:
//            storeNameLbl.text = "store name :".localized
//        case OrderType.parcelDelivery , OrderType.specialPackage :
//            storeNameLbl.text = "delegate name :".localized
//        default:
//            break
//        }

        orderState.text = order.status.localized

        switch order.status {
        case "Open".localized:
            orderState.textColor = .appColor(.MainColor)
        default:
            break
        }

        orderTime.text = order.createdAt
    }
}
