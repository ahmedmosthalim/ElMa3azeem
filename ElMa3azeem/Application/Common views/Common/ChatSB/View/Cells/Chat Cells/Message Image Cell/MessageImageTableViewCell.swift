//
//  MessageImageTableViewCell.swift
//  Teen
//
//  Created by Yosef Elbosaty on 11/11/2022.
//

import UIKit
import MapKit

class MessageImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var isSeen: UIImageView!
    @IBOutlet weak var cellBackgroundLeading: NSLayoutConstraint!
    @IBOutlet weak var cellBackgroundTrailing: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pickedImage.contentMode = .scaleToFill
    }
    
    override func prepareForReuse() {
        pickedImage.image = nil
    }
    
    //MARK:- Configure Image Cell
    func configureImageCell(message:Message){
        messageDate.text = message.time
        pickedImage.setImage(image: message.content)
        
    }
}
