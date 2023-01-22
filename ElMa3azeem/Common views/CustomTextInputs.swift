//
//  CustomTextInputs.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import Foundation
import UIKit

class AppTextFieldStyle: UITextField {
    public required init() {
        super.init(frame: .zero)
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(.placeHolderColor)!])
        tintColor = .appColor(.MainColor)
        keyboardAppearance = .dark
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.appColor(.placeHolderColor)!])
        tintColor = .appColor(.MainColor)
        keyboardAppearance = .dark
    }
}

class AppTextViewStyle: UITextView {
    var placeHolder: String? = "" {
        didSet {
            if text?.isEmpty == true {
                text = placeHolder
                textColor = UIColor.appColor(.placeHolderColor)
            }else{
                textColor = UIColor.appColor(.MainFontColor)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        delegate = self
        keyboardAppearance = .light
        tintColor = .appColor(.MainColor)
        textColor = UIColor.appColor(.MainFontColor)
    }
}

extension AppTextViewStyle: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.appColor(.placeHolderColor) {
            textView.text = nil
            textView.textColor = UIColor.appColor(.MainFontColor)
        }
        superview?.borderWidth = 1
        superview?.borderColor = UIColor.appColor(.MainColor)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = UIColor.appColor(.placeHolderColor)
        }
        superview?.borderWidth = 1
        superview?.borderColor = UIColor.appColor(.MainFontColor)
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == UIColor.appColor(.placeHolderColor) {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
}

class AppPickerTextFieldStyle: AppTextFieldStyle {
    var pickerView = UIPickerView()
    var datePickerView = UIDatePicker()
    var selectedDate = Date()
    var dataSorce: [GeneralPickerModel] = []
    var currentIndex = Int()
    var didSelected : (()->())?
    var pickerType: PickerType = .normal {
        didSet{
            switch pickerType {
            case .date:
                setupDatePickerView()
            case .normal:
                setupNormalPickerView()
            case .time:
                setupTimePickerView()
            case .generalTime:
                setupGeneralTime()
            }
        }
    }

    var selectedPickerData : GeneralPickerModel?
    
    enum PickerType {
        case date
        case time
        case normal
        case generalTime
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
            setupTimePickerView()
        case  .generalTime :
            setupGeneralTime()
            
        }
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

    // date picker
    private func setupDatePickerView() {
        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .inline
        datePickerView.minimumDate = Date()
        datePickerView.tintColor = .appColor(.MainColor)

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .appColor(.MainColor)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "confirm".localized, style: .done, target: self, action: #selector(dateDoneTapped))
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
    }

    // time picker
    private func setupTimePickerView() {
        
        datePickerView.datePickerMode = .time
        datePickerView.timeZone = .current
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.tintColor = .appColor(.MainColor)

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .appColor(.MainColor)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "confirm".localized, style: .done, target: self, action: #selector(timeDoneTapped))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        inputView = datePickerView
        inputAccessoryView = toolBar
        tintColor = UIColor.clear
    }

    @objc private func timeDoneTapped() {
        text = datePickerView.date.timeToString()
        selectedDate = datePickerView.date
        resignFirstResponder()
    }

    private func setupNormalPickerView() {
        pickerView.tintColor = .appColor(.MainColor)

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .appColor(.MainColor)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "confirm".localized, style: .done, target: self, action: #selector(normalDoneTapped))
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

extension AppPickerTextFieldStyle: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSorce.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSorce[row].pickerTitle.localized
    }
}
