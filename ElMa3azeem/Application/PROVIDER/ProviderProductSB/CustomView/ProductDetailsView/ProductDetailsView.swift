//  
//  ProductDetailsView.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/11/2022.
//

import UIKit

class ProductDetailsView: UIView {
    private let XIB_NAME = "ProductDetailsView"
    // MARK: - outlets -

    @IBOutlet weak var detailsLbl: UILabel!
    
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
    
    func configView(text : String){
        detailsLbl.text = text 
    }
}
