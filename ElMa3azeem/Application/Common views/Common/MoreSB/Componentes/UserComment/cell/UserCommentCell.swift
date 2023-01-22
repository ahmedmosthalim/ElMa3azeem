//
//  UserCommentCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 12/11/2022.
//

import UIKit
import Cosmos

class UserCommentCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellRate: CosmosView!
    
    @IBOutlet weak var cellDescription: UILabel!
    @IBOutlet weak var cellTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(review : Review?) {
        cellImage.setImage(image: review?.userAvatar ?? "", loading: true)
        cellTitle.text = review?.userName
        cellDescription.text = review?.comment
        cellRate.rating = Double(review?.rate ?? "") ?? 0.0
        cellTime.text = review?.createdAt
    }
    
}
