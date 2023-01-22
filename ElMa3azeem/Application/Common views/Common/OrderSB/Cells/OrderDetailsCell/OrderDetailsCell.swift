//
//  OrderDetailsCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2911/2022.
//

import UIKit

class OrderDetailsCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productDetailsLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    
    @IBOutlet weak var productQuantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configCell(product : Products?) {
        productImage.setImage(image: product?.image ?? "", loading: true)
        productNameLbl.text = product?.name ?? ""
        productDetailsLbl.text = product?.additives ?? ""
        productPriceLbl.text = product?.price.addAppCurrency ?? ""
        productQuantity.text = "\(product?.qty ?? 0)"
        
        if product?.additives ?? "" == "" {
            self.productDetailsLbl.isHidden = true
        }else{
            self.productDetailsLbl.isHidden = false
        }
    }
}
