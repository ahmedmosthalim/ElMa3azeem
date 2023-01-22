//
//  SelectedStoreCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit
 

class SelectedStoreCell: UITableViewCell {
    
    @IBOutlet weak var backGroundView: UIView!
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellStoreName: UILabel!
    @IBOutlet weak var cellAddress: UILabel!
    @IBOutlet weak var cellRate: UILabel!
    @IBOutlet weak var cellDistance: UILabel!
    
    @IBOutlet weak var stateview: UIView!
    @IBOutlet weak var stateLbl: UILabel!

    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var rateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func setupView() {
        
        if Language.isArabic() {
            backGroundView.setupChatBootStyleArabic()
        }else{
            backGroundView.setupChatBootStyleEnglish()
        }
    }
    
    func configeCell(store : Store? ) { cellImage.setImage(image: store?.icon ?? "", loading: true)
        cellStoreName.text = store?.name
        cellAddress.text = store?.address
        cellDistance.text = store?.distance
        cellRate.text = store?.rate

        if store?.isOpen == true {
            stateview.backgroundColor = UIColor.appColor(.StoreStateOpen)
            stateLbl.text = "Open".localized
        }else{
            stateview.backgroundColor = UIColor.appColor(.StoreStateClose)
            stateLbl.text = "Closed".localized
        }
    }
}
