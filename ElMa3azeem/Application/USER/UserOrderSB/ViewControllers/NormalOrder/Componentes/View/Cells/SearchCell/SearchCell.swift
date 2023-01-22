//
//  SearchCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1211/2022.
//

import UIKit
import SwiftUI

class SearchCell: UITableViewCell {

    @IBOutlet weak var searchTf: UITextField!
    
    var searchText : ((String)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        searchTf.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchTf.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension SearchCell : UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchText?(textField.text ?? "")
    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        searchText?(textField.text ?? "")
//    }
}

public extension UITextField {
    override var textInputMode: UITextInputMode? {
        return UITextInputMode.activeInputModes.filter { $0.primaryLanguage == "en" }.first ?? super.textInputMode
    }
}
