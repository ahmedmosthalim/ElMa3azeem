//
//  SubscriptionPackagesCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 13/11/2022.
//

import UIKit

class SubscriptionPackagesCell: UITableViewCell {

    @IBOutlet weak var containerBackgroundView : UIView!
    @IBOutlet weak var packageImage : UIImageView!
    @IBOutlet weak var packageTitleLbl : UILabel!
    @IBOutlet weak var packageDescriptionlbl : UILabel!
    @IBOutlet weak var packagePriceLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerBackgroundView.layer.borderColor = UIColor.appColor(.MainColor)?.cgColor
    }
    
    func configCell(package : ProviderPackagesModel){
        packageImage.setImage(image: package.logo)
        packageTitleLbl.text = package.name
        packageDescriptionlbl.text = package.description
        packagePriceLbl.text = package.price.addAppCurrency
        package.isSelected ?? false ? setupSelected() : setupNoitSelected()
        
    }
    
    private func setupSelected(){
        containerBackgroundView.layer.borderWidth = 1
    }
    
    private func setupNoitSelected(){
        containerBackgroundView.layer.borderWidth = 0
    }
}
