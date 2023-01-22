//
//  ProductAddFeatureCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 24/11/2022.
//

import UIKit

class ProductAddFeatureCell: UITableViewCell {
    
    @IBOutlet weak var featureTf: AppPickerTextFieldStyle!

    var addTapped: ((Int) -> Void)?
    var error: ((String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(item: [AppFeatureModel]?) {
        featureTf.setupData(data: item ?? [])
    }

    @IBAction func addFeatureAction(_ sender: Any) {
        if featureTf.text?.isEmpty == false {
            addTapped?(featureTf.currentIndex)
            featureTf.selectedPickerData = nil
            featureTf.text = ""
        }
    }
}
