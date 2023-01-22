//
//  ProviderBranchCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit

class ProviderBranchCell: UITableViewCell {
    @IBOutlet weak var branchNameLbl: UILabel!
    @IBOutlet weak var branchAddressLbl: UILabel!
    @IBOutlet weak var branchRateLbl: UILabel!

    var editBranchTapped : (()->())?
    var deleteBranchTapped : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configCell(branch: Branch?) {
        branchNameLbl.text = branch?.name
        branchAddressLbl.text = branch?.address
        branchRateLbl.text = branch?.rate
    }
    
    @IBAction func editBranchAction(_ sender: Any) {
        editBranchTapped?()
    }
    
    @IBAction func deleteBranchAction(_ sender: Any) {
        deleteBranchTapped?()
    }
}
