//
//  StoreCategoryCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1211/2022.
//

import UIKit

class StoreCategoryCell: UITableViewCell {
    @IBOutlet weak var backGround: UIView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDesctption: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var counterView: UIView!

    var selectCategory: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(model: Product?) {
        itemImage.setImage(image: model?.image ?? "", loading: true)
        itemDesctption.text = model?.desc
        itemPrice.attributedText = model?.displayPrice?.htmlToAttributedString
        itemPrice.font = UIFont.systemFont(ofSize: 12, weight: .semibold)

        if Language.isArabic() {
            itemPrice.textAlignment = .right
        } else {
            itemPrice.textAlignment = .left
        }

        if model?.quantity ?? 0 == 0 {
            counterView.isHidden = true
            backGround.layer.borderColor = nil
            backGround.layer.borderWidth = 0
        } else {
            counterView.isHidden = false
            countLbl.text = "x\(String(describing: model?.quantity ?? 0))"
            backGround.layer.borderColor = UIColor.appColor(.MainColor)?.cgColor
            backGround.layer.borderWidth = 2
        }

        itemTitle.text = model?.name
    }

    func configCell(model: ProviderProductData?) {
        itemImage.setImage(image: model?.image ?? "", loading: true)
        itemDesctption.text = model?.desc
        itemPrice.attributedText = model?.displayPrice.htmlToAttributedString
        itemPrice.font = UIFont.systemFont(ofSize: 12, weight: .semibold)

        if Language.isArabic() {
            itemPrice.textAlignment = .right
        } else {
            itemPrice.textAlignment = .left
        }

        counterView.isHidden = true

        itemTitle.text = model?.name
    }

    @IBAction func selectCategoryAction(_ sender: Any) {
        selectCategory?()
    }
}
