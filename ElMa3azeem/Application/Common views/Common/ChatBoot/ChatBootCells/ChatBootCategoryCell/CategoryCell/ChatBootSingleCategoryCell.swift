//
//  ChatBootSingleCategoryCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 02/11/2022.
//

import UIKit

class ChatBootSingleCategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configCell(title : String) {
        categoryLbl.text = title
    }
}
