//
//  SelectedCategotyCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 02/11/2022.
//

import UIKit
 

class SelectedCategotyCell: UITableViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    
    var selectStor : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        selectStor?()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        if Language.isArabic() {
            backGroundView.setupChatBootStyleArabic()
        }else{
            backGroundView.setupChatBootStyleEnglish()
        }
    }
    
    func configCell(title:String) {
        messageLbl.text = title
    }
}
