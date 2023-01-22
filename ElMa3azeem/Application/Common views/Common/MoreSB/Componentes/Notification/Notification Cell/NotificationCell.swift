//
//  NotififcationCell.swift
//  ElMa3azeem
//
//  Created by Mohamed Aglan on 111/22.
//

import UIKit
 

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var notificationDate: UILabel!
    @IBOutlet weak var notificationImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(notify : NotificationData) {
        notificationTitle.text = notify.title
        notificationDate.text = notify.createdAt
        notificationImage.setImage(image: notify.icon ?? "")
    }
}
