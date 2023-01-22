//
//  ProviderAddProductAdditionCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 23/11/2022.
//

import UIKit

class ProviderAddProductAdditionCell: UITableViewCell {
    @IBOutlet weak var arabicNameTf         : AppTextFieldStyle!
    @IBOutlet weak var englifhNameTf        : AppTextFieldStyle!
    @IBOutlet weak var priceTf              : AppTextFieldStyle!
    @IBOutlet weak var additionSection      : AppPickerTextFieldStyle!

    var deleteTapped: (() -> Void)?

    var updateArNameTapped: ((String) -> Void)?
    var updateEnNameTapped: ((String) -> Void)?
    var updatePriceTapped: ((String) -> Void)?
    var updateCategoryTapped: ((GeneralPicker) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        arabicNameTf.addTarget(self, action: #selector(updateArName), for: .editingDidEnd)
        englifhNameTf.addTarget(self, action: #selector(updateEnName), for: .editingDidEnd)
        priceTf.addTarget(self, action: #selector(updatePrice), for: .editingDidEnd)
        additionSection.addTarget(self, action: #selector(updateCategory), for: .editingDidEnd)
    }

    @objc func updateArName() {
        updateArNameTapped?(arabicNameTf.text ?? "")
    }

    @objc func updateEnName() {
        updateEnNameTapped?(englifhNameTf.text ?? "")
    }

    @objc func updatePrice() {
        updatePriceTapped?(priceTf.text ?? "")
    }

    @objc func updateCategory() {
        updateCategoryTapped?(GeneralPicker(id: additionSection.selectedPickerData?.pickerId ?? 0, title: additionSection.selectedPickerData?.pickerTitle ?? "", key: additionSection.selectedPickerData?.pickerKey ?? ""))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(nameAr: String, nameEn: String, price: String, type: GeneralPicker) {
        arabicNameTf.text = nameAr
        englifhNameTf.text = nameEn
        priceTf.text = price
        additionSection.text = type.title
    }

    @IBAction func deleteAction(_ sender: Any) {
        deleteTapped?()
    }
}
