//
//  WorkTimeCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1311/2022.
//

import UIKit

class WorkTimeCell: UITableViewCell {

    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configeCell(day : OpeningHour) {
        dayLbl.text = day.day
        timeLbl.text = day.time
        
        if day.time == "Closed".localized {
            timeLbl.textColor = UIColor.appColor(.StoreStateClose)
        }else{
            timeLbl.textColor = UIColor(hexString: "#989898")
        }
    }
}
