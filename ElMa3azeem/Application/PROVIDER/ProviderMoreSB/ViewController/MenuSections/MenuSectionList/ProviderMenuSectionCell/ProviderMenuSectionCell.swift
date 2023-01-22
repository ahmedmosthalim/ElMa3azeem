//
//  ProviderMenuSectionCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 18/11/2022.
//

import UIKit

class ProviderMenuSectionCell: UITableViewCell {
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuTime: UILabel!

    var editMenuTapped: (() -> Void)?
    var deleteMenuTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(title : String , time : String) {
        menuTitle.text = title
        menuTime.text = time
    }

    @IBAction func editAction(_ sender: Any) {
        editMenuTapped?()
    }

    @IBAction func deleteAction(_ sender: Any) {
        deleteMenuTapped?()
    }
}
