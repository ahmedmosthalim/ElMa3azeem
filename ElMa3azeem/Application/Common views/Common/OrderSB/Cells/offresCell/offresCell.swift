//
//  offresCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2911/2022.
//

import UIKit

class offresCell: UITableViewCell {

    @IBOutlet weak var delegateImage: UIImageView!
    @IBOutlet weak var delegateName: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    
    var acceptOffer : (()->())?
    var rejectOffer : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(offer : OrderOfferModel?) {
        delegateImage.setImage(image: offer?.delegateAvatar ?? "", loading: true)
        delegateName.text = offer?.delegateName
        deliveryPrice.text = "\(offer?.price ?? "") \(defult.shared.getAppCurrency() ?? "")"
    }
    
    @IBAction func acceptAction(_ sender: Any) {
        acceptOffer?()
    }
    @IBAction func rejectAction(_ sender: Any) {
        rejectOffer?()
    }
}
