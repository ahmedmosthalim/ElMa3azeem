//
//  SavedLocationCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2011/2022.
//

import UIKit

class SavedLocationCell : UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    
    var deleteAddress : (()->())?
    var editAddress : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(item : Address) {
        if item.title == "" {
            cellTitle.isHidden = true
        }else {
            cellTitle.isHidden = false
        }
        cellTitle.text = item.title
        cellDescription.text = item.address
    }
    
    @IBAction func deletaeAction(_ sender: Any) {
        deleteAddress?()
    }
    
    @IBAction func editAction(_ sender: Any) {
        editAddress?()
    }
    
}
