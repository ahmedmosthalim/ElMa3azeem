//
//  BranchCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1411/2022.
//

import UIKit

class BranchCell: UITableViewCell {

    @IBOutlet weak var branchImage: UIImageView!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var branchDistance: UILabel!
    @IBOutlet weak var branchSelectedIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell (branch : Branch , current : Int) {
        branchImage.setImage(image: branch.icon, loading: true)
        branchName.text = branch.name
        branchDistance.text = branch.distance
        
        if branch.id == current {
            branchSelectedIcon.image = UIImage(named: "branch_check")
        }else{
            branchSelectedIcon.image = UIImage(named: "")
        }
    }
}
