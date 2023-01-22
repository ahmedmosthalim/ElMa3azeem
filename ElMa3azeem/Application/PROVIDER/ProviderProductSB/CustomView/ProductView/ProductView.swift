//  
//  ProductView.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/11/2022.
//

import UIKit

class ProductView: UIView {
    private let XIB_NAME = "ProductView"

    // MARK: - outlets -
    @IBOutlet weak private var productImage: UIImageView!
    @IBOutlet weak private var productName: UILabel!
    @IBOutlet weak private var productPrice: UILabel!
    
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
    
    func configView(image : String , title : String , price : String){
        productImage.setImage(image: image, loading: true)
        productName.text = title
        productPrice.attributedText = price.htmlToAttributedString
        productPrice.textAlignment = Language.isArabic() ? .right : .left
        productPrice.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
}
