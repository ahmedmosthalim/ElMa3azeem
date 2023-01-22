//
//  PaymentWayCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1911/2022.
//

import UIKit

class PaymentWayCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    @IBOutlet weak var cellBackGround: UIView!
    @IBOutlet weak var selectImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.image = nil
        cellTitle.text = ""
        cellDescription.text = ""
        selectImage.isHidden = true
    }

    func configCell(item: PaymentMethod) {
        cellImage.setImage(image: item.image)
        cellTitle.text = item.name
        cellDescription.text = item.desc
        item.isSelected ?? false ? setupSelected() : setupNotSelected()
    }

    private func setupSelected() {
        cellBackGround.backgroundColor = UIColor.appColor(.MainColor)?.withAlphaComponent(0.40)
        cellBackGround.layer.borderColor = UIColor.appColor(.MainColor)?.cgColor
        cellBackGround.layer.borderWidth = 1
        selectImage.isHidden = false
    }

    private func setupNotSelected() {
        cellBackGround.backgroundColor = .appColor(.SecondViewBackGround)
        cellBackGround.layer.borderWidth = 0
        selectImage.isHidden = true
    }
}
