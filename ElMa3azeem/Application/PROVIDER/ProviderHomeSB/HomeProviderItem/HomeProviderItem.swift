//  
//  HomeProviderItem.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 20/11/2022.
//

import UIKit

class HomeProviderItem: UIView {
    let XIB_NAME = "HomeProviderItem"

    // MARK: - outlets -
    
    @IBOutlet weak var backGround: UIView!
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var viewTitleLbl: UILabel!
    @IBOutlet weak var numberLbl: UILabel!
    
    // MARK: - Init -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupUI()
    }

    // MARK: - Design -
    
    func setupUI(){
//        backGround.addBlurEffect(style: .systemThinMaterialDark, sendToBack: true)
    }

    private func commonInit() {
        guard let xib = Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)?.first, let viewFromXib = xib as? UIView else { return }
        viewFromXib.frame = bounds
        addSubview(viewFromXib)
    }
    
    func configView(number:Int,title:String ,image:String){
        self.numberLbl.text = "\(number)"
        self.viewTitleLbl.text = title
        self.viewImage.image = UIImage(named:"\(image)")
    }
    
    func updateNumber(number:Int?) {
        self.numberLbl.text = "\(number ?? 0)"
    }
}
