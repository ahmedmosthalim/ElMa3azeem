//
//  StoreWorkTimeCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 03/11/2022.
//

import SwiftMessages
import UIKit

class StoreWorkTimeCell: UITableViewCell {
    // MARK: - IBOutlet -

    @IBOutlet weak var dayTf: AppPickerTextFieldStyle!
    @IBOutlet weak var fromTf: AppPickerTextFieldStyle!
    @IBOutlet weak var toTf: AppPickerTextFieldStyle!
    @IBOutlet weak var addNewTimeBtn: UIButton!
    @IBOutlet weak var deleteTimeBtn: UIButton!
    @IBOutlet weak var fromView: AppTextFieldViewStyle!
    @IBOutlet weak var toView: AppTextFieldViewStyle!

    var addTimeTapped: ((GeneralPickerModel, Date, Date) -> Void)?
    var deleteTimeTapped: (() -> Void)?
    var errorSelecting: ((String) -> Void)?

    var updateDay: ((GeneralPickerModel) -> Void)?
    var updateFromDate: ((Date) -> Void)?
    var updateToDate: ((Date) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        dayTf.pickerType = .normal
        dayTf.setupData(data: weekDaysArray)
        fromTf.pickerType = .generalTime
        toTf.pickerType = .generalTime

        dayTf.addTarget(self, action: #selector(updateDayAction), for: .editingDidEnd)
        fromTf.addTarget(self, action: #selector(updateFromTimeAction), for: .editingDidEnd)
        toTf.addTarget(self, action: #selector(updateToTimeAction), for: .editingDidEnd)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dayTf.text = nil
        fromTf.text = nil
        toTf.text = nil
        addNewTimeBtn.isHidden = true
        deleteTimeBtn.isHidden = true
    }

    @objc func updateDayAction() {
        guard let day = dayTf.selectedPickerData else { return }
        updateDay?(day)
    }

    @objc func updateFromTimeAction() {
        if fromTf.text?.isEmpty ?? false {
            errorSelecting?("Please select a start time first.".localized)
            return
        }
//
//        if fromTf.selectedDate > toTf.selectedDate {
//            errorSelecting?("The start time must be before the closing time.".localized)
//            return
//        }

        updateFromDate?(fromTf.selectedDate)
    }

    @objc func updateToTimeAction() {
        if toTf.text?.isEmpty ?? false {
            errorSelecting?("Please select a closing time first.".localized)
            return
        }
//
//        if  toTf.selectedDate < fromTf.selectedDate {
//            errorSelecting?("The start time must be before the closing time.".localized)
//            return
//        }

        updateToDate?(toTf.selectedDate)
    }

    func configFiristCell() {
        addNewTimeBtn.isHidden = false
        deleteTimeBtn.isHidden = true
    }

    func configCell(time: OpeningHour?) {
        addNewTimeBtn.isHidden = true
        deleteTimeBtn.isHidden = false
        dayTf.text = time?.day
        fromTf.text = Language.isArabic() ? time?.from?.replacedEnglishDigitsWithArabic :  time?.from
        toTf.text =  Language.isArabic() ? time?.to?.replacedEnglishDigitsWithArabic : time?.to
    }

    @IBAction func addTimeAction(_ sender: Any) {
        guard let day = dayTf.selectedPickerData else { return }

        if fromTf.text?.isEmpty ?? false {
            errorSelecting?("Please select a start time first.".localized)
            return
        }

        if toTf.text?.isEmpty ?? false {
            errorSelecting?("Please select a closing time first.".localized)
            return
        }

        if fromTf.selectedDate > toTf.selectedDate {
            errorSelecting?("The start time must be before the closing time.".localized)
            return
        }

        print(day, fromTf.selectedDate, toTf.selectedDate)

        addTimeTapped?(day, fromTf.selectedDate, toTf.selectedDate)
    }

    @IBAction func deleteTimeAction(_ sender: Any) {
        deleteTimeTapped?()
    }
}
