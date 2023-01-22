//
//  SelectedProductCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1911/2022.
//

import UIKit

class SelectedProductCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    
    var counter = 0
    
    var increaseProduct : (()->())?
    var decreaseProduct : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configCell (item : SelectedProductModel) {
        cellImage.setImage(image: item.productIamge)
        productName.text = item.productName
        productPrice.text = "\(item.totalPrice) \(defult.shared.getAppCurrency() ?? "")"
        productDesc.text = ""
        
        item.feature.enumerated().forEach { (index,feature) in
            let selectedIndex = feature.properities?.firstIndex(where: {$0.isSelected == true}) ?? 0
            if index == 0 {
                productDesc.text?.append("\(feature.properities?[selectedIndex].name ?? "")")
            }else{
                productDesc.text?.append(" - \(feature.properities?[selectedIndex].name ?? "")")
            }
        }
        
        item.addition.enumerated().forEach { (index,addition) in
            let selectedIndex = addition.productAdditives.firstIndex(where: {$0.isSelected == true}) ?? 0
            if addition.productAdditives.isEmpty == false {
                if addition.productAdditives[selectedIndex].isSelected == true {
                    productDesc.text?.append(" - \(addition.productAdditives[selectedIndex].name ?? "")")
                }
            }
        }
        counter = item.quantity
        countLbl.text = "\(item.quantity)"
    }
    
    @IBAction func increaseAction(_ sender: Any) {
        increaseProduct?()
    }
    
    @IBAction func decreaseAction(_ sender: Any) {
        decreaseProduct?()
    }
    
}
