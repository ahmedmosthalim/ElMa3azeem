//  
//  OrderStoreDetailsView.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit

class OrderStoreDetailsView: UIView {
    let XIB_NAME = "OrderStoreDetailsView"

    // MARK: - outlets -
    @IBOutlet weak var storeImage       : UIImageView!
    @IBOutlet weak var storeNameLbl     : UILabel!
    @IBOutlet weak var storeAddressLbl  : UILabel!
    @IBOutlet weak var rateLbl          : UILabel!
    @IBOutlet weak var distanceLbl      : UILabel!
    
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Design -

    private func commonInit() {
        guard let xib = Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)?.first, let viewFromXib = xib as? UIView else { return }
        viewFromXib.frame = bounds
        addSubview(viewFromXib)
    }
    
    func configView(store : Store?){
        storeImage.setImage(image: store?.icon ?? "", loading: true)
        storeNameLbl.text = store?.name
        storeAddressLbl.text = store?.address
        rateLbl.text = store?.rate
        distanceLbl.text = store?.distance
    }
}
