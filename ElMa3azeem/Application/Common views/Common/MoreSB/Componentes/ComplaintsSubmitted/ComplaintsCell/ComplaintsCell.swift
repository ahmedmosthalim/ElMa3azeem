//
//  ComplaintsCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit

class ComplaintsCell: UITableViewCell {
    
    @IBOutlet weak var cellStoreImage: UIImageView!
    @IBOutlet weak var cellOrderID: UILabel!
    @IBOutlet weak var cellFamielyName: UILabel!
    @IBOutlet weak var cellOrderTime: UILabel!
    @IBOutlet weak var cellOrderState: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
    
    func configCell(item : Ticket) {
        cellStoreImage.setImage(image: item.order.image)
        cellOrderID.text = "\(item.id)"
        cellFamielyName.text = item.order.name
        cellOrderTime.text = item.createdAt
        cellOrderState.text = item.status
    }
}
