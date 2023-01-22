//
//  OrderDataCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2911/2022.
//

import UIKit

class OrderDataCell: UITableViewCell {

    @IBOutlet weak var cellBackGround: UIView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(title : String , description : String , index : Int) {
        cellTitle.text = title
        cellDescription.text = description
        if index % 2 == 0 {
            cellBackGround.backgroundColor = .white
        }else{
            cellBackGround.backgroundColor = UIColor(hexString: "#F8F8F8")
        }
    }
}
