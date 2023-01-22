//
//  ChatTableViewCell.swift
//  Teen
//
//  Created by Yosef Elbosaty on 19/11/2022.
//

import UIKit

class MessageTextTableViewCell: UITableViewCell {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var isSeen: UIImageView!
    @IBOutlet weak var cellBackgroundLeading: NSLayoutConstraint!
    @IBOutlet weak var cellBackgroundTrailing: NSLayoutConstraint!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        message.sizeToFit()
        cellBackground.layer.cornerRadius = 20
    }
    
    func configureCell(message:Message){
        self.message.text = message.content
        messageDate.text = message.time

        cellWidth.constant = message.content.size(withAttributes: nil).width 
    }
}
