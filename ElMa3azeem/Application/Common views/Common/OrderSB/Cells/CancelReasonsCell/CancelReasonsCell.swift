//
//  CancelReasonsCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 04/01/2022.
//

import UIKit

class CancelReasonsCell: UITableViewCell {

    @IBOutlet weak var cellBackGround: UIView!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func configSelected(){
        cellTitle.textColor = .appColor(.MainFontColor)
        selectImage.image = UIImage(named: "circle-mark-selected")
    }
    
    private func configNotSelected(){
        cellTitle.textColor = .appColor(.MainFontColor)
        selectImage.image = UIImage(named: "circle-mark-not-selected")
    }
    
    func configCell(item : ReasonsData) {
        cellTitle.text = item.reason
        if item.isSelected ?? false {
            configSelected()
        }else{
            configNotSelected()
        }
    }
}
