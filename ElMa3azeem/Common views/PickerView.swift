//
//  PickerView.swift
//  ElMa3azeem
//
//  Created by Ahmed Mostafa on 29/11/2022.
//

import Foundation
import UIKit

class PickerTextField: UITextField {
    var selectedDate = Date()
    var selectedTime = Date()
    private var pickerView = UIPickerView()
    private var datePickerView = UIDatePicker()
    private var timePickerView = UIDatePicker()
    private var currentIndex = Int()
    private var isLast = false
    private var isLaterDate = false
    
    var didSelected: (() -> Void)?
    var didSelectWithError: ((String) -> Void)?
    var isLastActive: ((Bool) -> Void)?
    
    var selectedPickerData: GeneralPickerModel?
    var dataSorce: [GeneralPickerModel] = []
    var isOlderDateAvilable = false
    var isOlderTimeAvilable = false
    
    enum PickerType {
        case date
        case time
        case normal
        case generalDate
        case generalTime
    }
    
    var pickerType: PickerType = .normal {
        didSet {
            switch pickerType {
            case .date:
                setupDatePickerView()
            case .normal:
                setupNormalPickerView()
            case .time:
                setupdatePickerView()
            case .generalDate :
                setupGeneralDate()
            case .generalTime :
                setupGeneralTime()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        switch pickerType {
        case .date:
            setupDatePickerView()
        case .normal:
            setupNormalPickerView()
        case .time:
            setupdatePickerView()
        case .generalDate :
            setupGeneralDate()
        case .generalTime :
            setupGeneralTime()
        }
    }
    
    private func setupGeneralDate(){
        
    }
    private func setupGeneralTime(){
    
        datePickerView.datePickerMode = .time
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.tintColor = UIColor.appColor(.MainColor)
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.appColor(.MainColor)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Confirm".localized, style: .done, target: self, action: #selector(timeDoneTapped))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inputView = datePickerView
        inputAccessoryView = toolBar
        tintColor = UIColor.clear
    }
    
    
    func setupData(data: [GeneralPickerModel]) {
        dataSorce = data
        pickerView.reloadAllComponents()
    }
    
    func setupDateSatet(date : Date?) {
        if date! > Date() {
            isLaterDate = true
            isOlderTimeAvilable = true
        }else{
            isLaterDate = false
            isOlderTimeAvilable = false
        }
    }
    
    // date picker
    private func setupDatePickerView() {
        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .inline
        
        if isOlderDateAvilable == false {
            datePickerView.minimumDate = Date()
        }
        
        datePickerView.tintColor = UIColor.appColor(.MainColor)
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.appColor(.MainColor)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Confirm".localized, style: .done, target: self, action: #selector(dateDoneTapped))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inputView = datePickerView
        inputAccessoryView = toolBar
        tintColor = UIColor.clear
    }
    
    @objc private func dateDoneTapped() {
        text = datePickerView.date.dateToString
        selectedDate = datePickerView.date
        resignFirstResponder()
        didSelected?()
    }
    
    // time picker
    func setupMinTime()
    {
        if datePickerView.minimumDate == Date()
        {
            datePickerView.minimumDate = Date()
        }
    }
    private func setupdatePickerView() {
        
        if isOlderTimeAvilable == false {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat =  "HH:mm"
            let min = dateFormatter.date(from: Date().apiTime())
            datePickerView.minimumDate = min
        }
        
        
        datePickerView.datePickerMode = .time
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.tintColor = UIColor.appColor(.MainColor)
        
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.appColor(.MainColor)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Confirm".localized, style: .done, target: self, action: #selector(timeDoneTapped))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inputView = datePickerView
        inputAccessoryView = toolBar
        tintColor = UIColor.clear
    }
    
    @objc private func timeDoneTapped() {
        if isLaterDate {
            text = datePickerView.date.timeToString()
            selectedDate = datePickerView.date
            resignFirstResponder()
            didSelected?()
        }else{
            if isOlderTimeAvilable == false , datePickerView.date < Date() {
                didSelectWithError?("The selected time not correct".localized)
            }else{
                text = datePickerView.date.timeToString()
                selectedDate = datePickerView.date
                resignFirstResponder()
                didSelected?()
            }
        }
        
        
//        if isOlderTimeAvilable == false ,
//            {
//            didSelectWithError?("The selected time not correct".localized)
//        }else{
//
//        }
    }
    
    private func setupNormalPickerView() {
        
        pickerView.tintColor = UIColor.appColor(.MainColor)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.appColor(.MainColor)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Confirm".localized, style: .done, target: self, action: #selector(normalDoneTapped))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inputView = pickerView
        inputAccessoryView = toolBar
        tintColor = UIColor.clear
    }
    
    @objc private func normalDoneTapped() {
        if !dataSorce.isEmpty {
            text = dataSorce[pickerView.selectedRow(inComponent: 0)].pickerTitle.localized
            selectedPickerData = dataSorce[pickerView.selectedRow(inComponent: 0)]
            currentIndex = pickerView.selectedRow(inComponent: 0)
            didSelected?()
            resignFirstResponder()
        }
    }
}

extension PickerTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSorce.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSorce[row].pickerTitle.localized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isLast = row == dataSorce.count - 1
        isLastActive?(isLast)
    }
}

