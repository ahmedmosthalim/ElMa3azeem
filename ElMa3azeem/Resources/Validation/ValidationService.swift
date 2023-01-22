import Foundation

struct ValidationService {
    // MARK: - Name -

    static func validate(firstName: String?) throws -> String {
        guard let firstName = firstName, !firstName.isEmpty else {
            throw ValidationError.emptyFirstName
        }
        guard firstName.count > 2 else {
            throw ValidationError.shortFirstName
        }
        guard firstName.count < 61 else {
            throw ValidationError.longFirstName
        }
        return firstName
    }

    static func validate(lastName: String?) throws -> String {
        guard let lastName = lastName, !lastName.isEmpty else {
            throw ValidationError.emptyLastName
        }
        guard lastName.count > 2 else {
            throw ValidationError.shortLastName
        }
        guard lastName.count < 61 else {
            throw ValidationError.longLastName
        }
        return lastName
    }

    static func validate(familyName: String?) throws -> String {
        guard let familyName = familyName, !familyName.isEmpty else {
            throw ValidationError.emptyFamilyName
        }
        guard familyName.count > 2 else {
            throw ValidationError.shortFamilyName
        }
        guard familyName.count < 61 else {
            throw ValidationError.longFamilyName
        }
        return familyName
    }

    static func validate(fullName: String?) throws -> String {
        guard let fullName = fullName, !fullName.isEmpty else {
            throw ValidationError.emptyFullName
        }
        guard fullName.count > 2 else {
            throw ValidationError.shortFullName
        }
        return fullName
    }

    static func validate(name: String?) throws -> String {
        guard let name = name, !name.isEmpty else {
            throw ValidationError.emptyName
        }
        guard name.count > 2 else {
            throw ValidationError.shortName
        }
        guard name.count < 61 else {
            throw ValidationError.longName
        }
        return name
    }

    // MARK: - Phone -

    static func validate(phone: String?) throws -> String {
        guard let phone = phone, !phone.isEmpty else {
            throw ValidationError.emptyPhoneNumber
        }

        guard phone.count > 8 else {
            throw ValidationError.incorrectPhoneNumber
        }

        return phone
    }

    static func validatePhone(_ phone: String?) throws {
        guard let phone = phone, !phone.isEmpty else {
            throw ValidationError.emptyPhoneNumber
        }
        guard phone.count > 8 && phone.count < 15 else {
            throw ValidationError.incorrectPhoneNumber
        }
    }

    static func validateName(_ name: String?) throws {
        guard let name = name, !name.isEmpty else {
            throw ValidationError.emptyName
        }
        guard name.count >= 3 else {
            throw ValidationError.shortName
        }
    }
    // MARK: - Car  -
    static func carModel(_ name: String?)  throws  -> String{
        guard let name = name, !name.isEmpty else {
            throw ValidationError.emptyName
        }
        guard name.count >= 3 else {
            throw ValidationError.shortName
        }
        return name
    }
    static func carModelYear(carModelYear: String?) throws -> String {
        guard let carModelYear = carModelYear, !carModelYear.isEmpty else {
            throw ValidationError.emptyYear
        }
        guard carModelYear.count == 4 else {
            throw ValidationError.incorrectYear
        }
        guard  Int(carModelYear)! > 1970 else
        {
            throw ValidationError.oldCar
        }
        guard Int(carModelYear)! < 2024  else
        {
            throw ValidationError.incorrectYear
        }
        return carModelYear
    }
    static func carPlateInLetters(_ name: String?) throws  -> String {
        guard let name = name, !name.isEmpty else {
            throw ValidationError.emptyPlateLetters
        }
        guard name.count <= 5 else {
            throw ValidationError.incorrectPlateLetter
        }
        return name
    }
    static func carPlateInNumbers(carPlateInLetters: String?) throws -> String {
        guard let carPlateInLetters = carPlateInLetters, !carPlateInLetters.isEmpty else {
            throw ValidationError.emptyPlateNumber
        }
        guard carPlateInLetters.count <= 5 else {
            throw ValidationError.incorrectPlateNumber
        }
        return carPlateInLetters
    }
    
    
    

    // MARK: - Verification code -

    static func validate(verificationCode: String?) throws -> String {
        guard let verificationCode = verificationCode, !verificationCode.isEmpty else {
            throw ValidationError.emptyVerificationCode
        }
        guard verificationCode.count == 6 else {
            throw ValidationError.incorrectVerificationCode
        }
        return verificationCode
    }

    static func validateVerificationCode(verificationCode: String?) throws {
        guard let verificationCode = verificationCode, !verificationCode.isEmpty else {
            throw ValidationError.emptyVerificationCode
        }
        guard verificationCode.count == 6 else {
            throw ValidationError.incorrectVerificationCode
        }
    }

    // MARK: - Email -

    static func validate(email: String?) throws -> String {
        guard let email = email, !email.isEmpty else {
            throw ValidationError.emptyMail
        }
        guard email.isValidEmail() else {
            throw ValidationError.wrongMail
        }
        return email
    }

    static func validateEmail(_ email: String?) throws -> String {
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty else {
            throw ValidationError.emptyMail
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        guard emailPred.evaluate(with: email) else {
            throw ValidationError.wrongMail
        }

        return email
    }

    static func validateEmptyText(_ text: String?) throws {
        guard let text = text, !text.isEmpty else {
            throw ValidationError.emptyMessage
        }
    }

    // MARK: - Passwords -

    static func validate(password: String?) throws -> String {
        guard let password = password, !password.isEmpty else {
            throw ValidationError.emptyPassword
        }
        guard password.count > 7 else {
            throw ValidationError.shortPassword
        }
        return password
    }

    static func validate(newPassword: String?) throws -> String {
        guard let newPassword = newPassword, !newPassword.isEmpty else {
            throw ValidationError.emptyNewPassword
        }
        guard newPassword.count > 5 else {
            throw ValidationError.shortNewPassword
        }
        return newPassword
    }

    static func validate(oldPassword: String?) throws -> String {
        guard let oldPassword = oldPassword, !oldPassword.isEmpty else {
            throw ValidationError.emptyOldPassword
        }
        guard oldPassword.count > 5 else {
            throw ValidationError.shortOldPassword
        }
        return oldPassword
    }

    static func validate(newPassword: String, confirmNewPassword: String?) throws -> String {
        guard let confirmNewPassword = confirmNewPassword, !confirmNewPassword.isEmpty else {
            throw ValidationError.emptyConfirmNewPassword
        }
        guard newPassword == confirmNewPassword else {
            throw ValidationError.notMatchPasswords
        }
        return newPassword
    }

    static func validate(newPassword: String, confirmPassword: String?) throws -> String {
        guard let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            throw ValidationError.emptyConfirmPassword
        }
        guard newPassword == confirmPassword else {
            throw ValidationError.notMatchPasswords
        }
        return newPassword
    }

    static func validate(password: String, confirmPassword: String?) throws {
        guard let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            throw ValidationError.emptyConfirmPassword
        }
        guard password == confirmPassword else {
            throw ValidationError.notMatchPasswords
        }
    }

    // MARK: - Location -

    static func validate(countryId: Int?) throws -> Int {
        guard let countryId = countryId else {
            throw ValidationError.emptyCountry
        }
        return countryId
    }

    static func validate(governorateId: Int?) throws -> Int {
        guard let governorateId = governorateId else {
            throw ValidationError.emptyGovernorate
        }
        return governorateId
    }

    static func validate(cityId: Int?) throws -> Int {
        guard let cityId = cityId, cityId != 0 else {
            throw ValidationError.emptyCity
        }
        return cityId
    }
    static func validate(Regions : [RegionModel]) throws -> Bool {
        guard !Regions.isEmpty else {
            throw ValidationError.emptyRegion
        }
        return true
    }
    
    static func validate(cities: [CitiesModel]) throws -> Bool {
        guard !cities.isEmpty else {
            throw ValidationError.emptyCity
        }
        return true
    }

    static func validate(areaId: Int?) throws -> Int {
        guard let areaId = areaId else {
            throw ValidationError.emptyArea
        }
        return areaId
    }

    static func validate(streetName: String?) throws -> String {
        guard let streetName = streetName, !streetName.isEmpty else {
            throw ValidationError.emptyStreet
        }
        return streetName
    }

    static func validate(floor: String?) throws -> String {
        guard let floor = floor, !floor.isEmpty else {
            throw ValidationError.emptyStreet
        }
        return floor
    }

    static func validate(department: String?) throws -> String {
        guard let department = department, !department.isEmpty else {
            throw ValidationError.emptyStreet
        }
        return department
    }

    static func validate(addressType: String?) throws -> String {
        guard let addressType = addressType, !addressType.isEmpty else {
            throw ValidationError.addressType
        }
        return addressType
    }

    static func validate(gender: String?) throws {
        guard let gender = gender, !gender.isEmpty else {
            throw ValidationError.emptyGender
        }
    }

    static func validate(nationality: String?) throws {
        guard let nationality = nationality, !nationality.isEmpty else {
            throw ValidationError.emptyNationality
        }
    }

    static func validate(region: String?) throws {
        guard let region = region, !region.isEmpty else {
            throw ValidationError.emptyArea
        }
    }

    static func validate(address: String?, lat: Double?, long: Double?) throws -> (address: String, lat: Double, long: Double) {
        guard let address = address, !address.isEmpty else {
            throw ValidationError.emptyLocation
        }

        guard let lat = lat, let long = long else {
            throw ValidationError.emptyLocation
        }

        return (address, lat, long)
    }

    // MARK: - Images -

    static func validate(profilePicture: Data?) throws -> Data {
        guard let profilePicture = profilePicture else {
            throw ValidationError.profilePicture
        }
        return profilePicture
    }
    static func validate(productPicture: Data?) throws -> Data {
        guard let productPicture = productPicture else {
            throw ValidationError.productPicture
        }
        return productPicture
    }

    static func validate(licensePicture: Data?) throws -> Data {
        guard let licensePicture = licensePicture else {
            throw ValidationError.licensePicture
        }
        return licensePicture
    }

    // MARK: - Cars -

    static func validate(carPicture: Data?) throws -> Data {
        guard let carPicture = carPicture else {
            throw ValidationError.carPicture
        }
        return carPicture
    }

    static func validate(carPlate: String?) throws -> String {
        guard let carPlate = carPlate, !carPlate.isEmpty else {
            throw ValidationError.carPlate
        }
        return carPlate
    }

    static func validate(carModel: Int?) throws -> Int {
        guard let carModel = carModel else {
            throw ValidationError.carModel
        }
        return carModel
    }

    static func validate(carType: Int?) throws -> Int {
        guard let carType = carType else {
            throw ValidationError.carType
        }
        return carType
    }

    // MARK: - CreateOrder

    static func validate(selectProduct: [SelectedProductModel]?) throws -> [SelectedProductModel] {
        guard let selectProduct = selectProduct, !selectProduct.isEmpty else {
            throw ValidationError.emptyProducts
        }
        return selectProduct
    }

    static func validate(paymentWay: String?) throws -> String {
        guard let paymentWay = paymentWay, !paymentWay.isEmpty else {
            throw ValidationError.emptyPaymenWay
        }
        return paymentWay
    }

    static func validate(cashPaymentMethod: String?) throws -> String {
        guard let cashPaymentMethod = cashPaymentMethod, !cashPaymentMethod.isEmpty else {
            throw ValidationError.delegatePaymentStateForUser
        }

        guard cashPaymentMethod == "cash" else {
            throw ValidationError.delegatePaymentStateForUser
        }

        return cashPaymentMethod
    }

    static func validate(productPrice: String?) throws -> String {
        guard let productPrice = productPrice, !productPrice.isEmpty else {
            throw ValidationError.emptyProductPrice
        }
        return productPrice
    }

    static func validate(deliveryPrice: String?) throws -> String {
        guard let deliveryPrice = deliveryPrice, !deliveryPrice.isEmpty else {
            throw ValidationError.emptyProductPrice
        }
        return deliveryPrice
    }

    static func validate(complainteReasone: String?) throws -> String {
        guard let complainteReasone = complainteReasone, !complainteReasone.isEmpty else {
            throw ValidationError.emptyComplpainteReasone
        }
        return complainteReasone
    }

    static func validate(paymentState: Bool?) throws -> Bool {
        guard let paymentState = paymentState else {
            throw ValidationError.delegatePaymentStateForUser
        }

        guard paymentState == true else {
            throw ValidationError.delegatePaymentStateForUser
        }

        return paymentState
    }

    static func validate(deliveryLat: String?, deliveryLong: String?) throws -> (lat: String, long: String) {
        guard let deliveryLat = deliveryLat, !deliveryLat.isEmpty else {
            throw ValidationError.emptyDeliveryLocation
        }
        guard let deliveryLong = deliveryLong, !deliveryLong.isEmpty else {
            throw ValidationError.emptyDeliveryLocation
        }
        return (deliveryLat, deliveryLong)
    }

    static func validate(reciveLat: String?, reciveLong: String?) throws -> (lat: String, long: String) {
        guard let reciveLat = reciveLat, !reciveLat.isEmpty else {
            throw ValidationError.emptyReciveLocation
        }
        guard let reciveLong = reciveLong, !reciveLong.isEmpty else {
            throw ValidationError.emptyReciveLocation
        }
        return (reciveLat, reciveLong)
    }

    static func validate(deliveryTime: String?) throws -> String {
        guard let deliveryTime = deliveryTime, !deliveryTime.isEmpty else {
            throw ValidationError.emptyDeliveryTime
        }
        return deliveryTime
    }

    static func validate(deliveryDate: String?) throws -> String {
        guard let deliveryDate = deliveryDate, !deliveryDate.isEmpty else {
            throw ValidationError.emptyDeliveryDate
        }
        return deliveryDate
    }

    static func validate(orderDetails: String?) throws -> String {
        guard let orderDetails = orderDetails, !orderDetails.isEmpty else {
            throw ValidationError.emptyOrderDetails
        }

        guard orderDetails != "If there are comments, add here".localized else {
            throw ValidationError.emptyOrderDetails
        }

        guard orderDetails.count > 2 else {
            throw ValidationError.shortOrderDetails
        }

        return orderDetails
    }

    static func validate(complaintDetails: String?) throws -> String {
        guard let complaintDetails = complaintDetails, !complaintDetails.isEmpty else {
            throw ValidationError.emptyComplainteDetails
        }

        guard complaintDetails != "Please enter complaint details".localized else {
            throw ValidationError.emptyComplainteDetails
        }

        guard complaintDetails.count > 2 else {
            throw ValidationError.shortComplainteDetails
        }

        return complaintDetails
    }

    static func validate(comment: String?) throws -> String {
        guard let comment = comment, !comment.isEmpty else {
            throw ValidationError.emptyOrderDetails
        }

        guard comment != "If there are comments, add here".localized else {
            throw ValidationError.emptyComment
        }

        guard comment.count > 2 else {
            throw ValidationError.shortComment
        }

        return comment
    }

    static func validate(rate: Double?) throws -> Double {
        guard let rate = rate else {
            throw ValidationError.rateIsEmpty
        }

        guard rate > 0 else {
            throw ValidationError.rateIsEmpty
        }

        return rate
    }

    static func validate(coupon: String?) throws -> String {
        guard let coupon = coupon, !coupon.isEmpty else {
            throw ValidationError.emptyCopoun
        }
        return coupon
    }

    // MARK: - Product

    static func validate(productNameAr: String?) throws {
        guard let productNameAr = productNameAr, !productNameAr.isEmpty else {
            throw ValidationError.emptyProductNameAr
        }
    }

    static func validate(productNameEr: String?) throws {
        guard let productNameEr = productNameEr, !productNameEr.isEmpty else {
            throw ValidationError.emptyProductNameEn
        }
    }

    static func validate(productPriceDiscount: String?) throws {
        guard let productPriceDiscount = productPriceDiscount, !productPriceDiscount.isEmpty else {
            throw ValidationError.emptyProductPriceDiscount
        }
    }

    static func validate(selectMenu: String?) throws {
        guard let selectMenu = selectMenu, !selectMenu.isEmpty else {
            throw ValidationError.emptyMenu
        }
    }

    static func validate(stockType: String?) throws {
        guard let stockType = stockType, !stockType.isEmpty else {
            throw ValidationError.emptyStockType
        }
    }

    static func validate(quanty: String?) throws {
        guard let quanty = quanty, !quanty.isEmpty else {
            throw ValidationError.emptyQuanty
        }
    }

    static func validate(productDescriptionAr: String?) throws {
        guard let productDescriptionAr = productDescriptionAr, !productDescriptionAr.isEmpty else {
            throw ValidationError.emptyProductDescriptionAr
        }
    }

    static func validate(productDescriptionEn: String?) throws {
        guard let productDescriptionEn = productDescriptionEn, !productDescriptionEn.isEmpty else {
            throw ValidationError.emptyProductDescriptionEn
        }
    }

    static func validate(productType: String?) throws {
        guard let productType = productType, !productType.isEmpty else {
            throw ValidationError.emptyProductType
        }
    }

    static func validate(productPricee: String?) throws {
        guard let productPricee = productPricee, !productPricee.isEmpty else {
            throw ValidationError.emptyProductPrice
        }
    }

    static func validate(productPriceeDiscount: String?) throws {
        guard let productPriceeDiscount = productPriceeDiscount, !productPriceeDiscount.isEmpty else {
            throw ValidationError.emptyProductPriceDiscount
        }
    }

    static func validate(fromeDate: Date?, toDate: Date?) throws {
        guard fromeDate ?? Date() <= toDate ?? Date() else {
            throw ValidationError.emptyProductPriceDiscount
        }
    }

    static func validate(normalPrice: String?, discountPrice: String?) throws {
        let normalPrice = Double(normalPrice ?? "") ?? 0
        let discountPrice = Double(discountPrice ?? "") ?? 0
        guard normalPrice > discountPrice else {
            throw ValidationError.notValidateDiscount
        }
    }

    static func validate(nameAr: String?) throws {
        guard let nameAr = nameAr, !nameAr.isEmpty else {
            throw ValidationError.emptyNameAr
        }

        guard nameAr.count > 2 else {
            throw ValidationError.emptyNameAr
        }
    }

    static func validate(nameEn: String?) throws {
        guard let nameEn = nameEn, !nameEn.isEmpty else {
            throw ValidationError.emptyNameEn
        }

        guard nameEn.count > 2 else {
            throw ValidationError.emptyNameEn
        }
    }

    static func validate(category: String?) throws {
        guard let category = category, !category.isEmpty else {
            throw ValidationError.category
        }
    }

    static func validate(baankAccountNumber: String?) throws {
        guard let baankAccountNumber = baankAccountNumber, !baankAccountNumber.isEmpty else {
            throw ValidationError.banckAcrounNum
        }

        guard baankAccountNumber.count > 9 else {
            throw ValidationError.banckAcrounNum
        }
    }

    static func validate(ibanNumber: String?) throws {
        guard let ibanNumber = ibanNumber, !ibanNumber.isEmpty else {
            throw ValidationError.ibanNum
        }

        guard ibanNumber.count > 9 else {
            throw ValidationError.ibanNum
        }
    }

    static func validate(commirtialID: String?) throws {
        guard let commirtialID = commirtialID, !commirtialID.isEmpty else {
            throw ValidationError.ibanNum
        }

        guard commirtialID.count > 9 else {
            throw ValidationError.ibanNum
        }
    }

    static func validate(bankName: String?) throws {
        guard let bankName = bankName, !bankName.isEmpty else {
            throw ValidationError.emptyBankName
        }

        guard bankName.count > 2 else {
            throw ValidationError.emptyBankName
        }
    }

    // provider add branch

    static func validate(branchName: String?) throws -> String {
        guard let branchName = branchName, !branchName.isEmpty else {
            throw ValidationError.emptyNameAr
        }

        guard branchName.count > 2 else {
            throw ValidationError.emptyNameAr
        }
        return branchName
    }
    
    static func validate(amount: String?) throws {
        guard let amount = amount, !amount.isEmpty else {
            throw ValidationError.emptyAmount
        }

        guard amount.count > 1 else {
            throw ValidationError.emptyAmount
        }
    }

    static func validate(group: AddProductGroupModel?) throws {
        guard group?.features.filter({ $0.selectedProperity == nil }).count ?? 0 <= 0 else {
            throw ValidationError.emptyPreperity
        }
        
        guard let _ = group?.price, !(group?.price.isEmpty ?? false) else {
            throw ValidationError.emptyProductPrice
        }

        guard let _ = group?.qty, !(group?.qty.isEmpty ?? false) else {
            throw ValidationError.emptyProductDescriptionAr
        }

        if group?.discountPrice != "" {
            guard Int(group?.discountPrice ?? "") ?? 0 < Int(group?.price ?? "") ?? 0 else {
                throw ValidationError.notValidateDiscount
            }
        }

        guard group?.from ?? Date() < group?.to ?? Date() else {
            throw ValidationError.notValidateDate
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
