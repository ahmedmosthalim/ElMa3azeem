//
//  DateExtentions.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 03/11/2022.
//

import Foundation

extension Date {
    func arabicTimeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ar")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }

    func englishTimeToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }

    func apiTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }

    func arabicDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ar")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }

    func englishDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }

    func apiDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    var dateToString: String? {
        return Language.isArabic() ? arabicDateToString() : englishDateToString()
    }

    func timeToString() -> String {
        return Language.isArabic() ? arabicTimeToString() : englishTimeToString()
    }
}
