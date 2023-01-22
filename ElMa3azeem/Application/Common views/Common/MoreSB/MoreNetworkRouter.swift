//
//  MoreNetworkRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import Alamofire
import Foundation

enum MoreNetworkRouter {
    case showProfile

    case userUpadteProfile(name: String, phoneNumber: String, countryCode: String, email: String, nationalityId: Int, cityID: Int, address: String, lat: String, long: String, gender: String)
    case providerUpadteProfile(name: String?, phoneNumber: String?, countryCode: String?, email: String?)
    case delegateUpdateProfile(name: String, phoneNumber: String, countryCode: String, address: String, lat: String, long: String, cityID: Int, regionID: Int)
    case delegateUpdateCarInfo(carModel:String,carModelYear:String,carPlateInNumbers:String,carPlateInLetters:String)
    case updateProfileSocialLogin(name: String?, phoneNumber: String?, countryCode: String?, email: String?, token: String)
    case changePhone(code: String)
    case confirmPhoneSocialLogin(code: String, token: String)
    case getTicket
    case singleTicket(ticketId: Int)
    case wallet
    case userReviews
    case policy
    case cities(id: Int)
    case regions(id:Int)
    case terms
    case about
    case contactUs(name: String, phone: String, message: String)
    case notification(page: Int)
    case notificationControll(offerNotify: String?, newOrder: String?)
    case deleteProfile
    case getFavorite(page: Int)
    case nationalities
    case getCarTypes
}

extension MoreNetworkRouter: URLRequestBuilder {
    // MARK: - Paths

    internal var path: ServiceURL {
        switch self {
        case .showProfile:
            return .profileShow
        case .userUpadteProfile:
            return .profileUpdate
        case .providerUpadteProfile:
            return .profileUpdate
        case .updateProfileSocialLogin:
            return .profileUpdate
        case .delegateUpdateProfile , .delegateUpdateCarInfo:
            return .delegateProfileUpdate
        case .changePhone:
            return .changePhone
        case .confirmPhoneSocialLogin:
            return .changePhone
        case .getTicket:
            return .getTicket
        case .singleTicket:
            return .singleTicket
        case .wallet:
            return .wallet
        case .userReviews:
            return .userReviews
        case .policy:
            return .policy
        case .terms:
            return .terms
        case .cities:
            return .cities
        case .contactUs:
            return .contactUs
        case .notification:
            return .notification
        case .notificationControll:
            return .notificationControll
        case .deleteProfile:
            return .DeleteProfile
        case .getFavorite:
            return .getFavourites
        case .nationalities:
            return .nationalities
        case .about:
            return .about
        case .regions :
              return .regions
        case .getCarTypes :
            return .cartypes
        }
    }

    // MARK: - Parameters

    internal var parameters: Parameters? {
        var params = Parameters()
        switch self {
        case .updateProfileSocialLogin(name: let name, phoneNumber: let phone, countryCode: let code, email: let mail, token: _):

            if let name = name, let phone = phone, let code = code, let mail = mail {
                params = [
                    "name": name,
                    "email": mail,
                    "country_key": code,
                    "phone": phone,
                ]
            }

        case let .userUpadteProfile(name: name, phoneNumber: phoneNumber, countryCode: countryCode, email: email, nationalityId: nationalityId, cityID: cityID, address:
            address, lat: lat, long: long, gender: gender):
            params = [
                "name": name,
                "country_key": countryCode,
                "phone": phoneNumber,
                "email": email,
                "lat": lat,
                "long": long,
                "address": address,
                "nationality_id": nationalityId,
                "city_id": cityID,
                "gender": gender,
            ]

        case let .providerUpadteProfile(name, phoneNumber, countryCode, email):
            if let name = name, let phone = phoneNumber, let code = countryCode, let email = email {
                params = [
                    "name": name,
                    "country_key": code,
                    "phone": phone,
                    "email": email,
                ]
            }

        case let .delegateUpdateProfile(name: name, phoneNumber: phoneNumber, countryCode: countryCode, address: address, lat: lat, long: long, cityID: cityID, regionID: regionID):
            params = [
                "name": name,
                "country_key": countryCode,
                "phone": phoneNumber,
                "lat": lat,
                "long": long,
                "address": address,
                "city_id": cityID,
                "region_id" : regionID
            ]
        case let .delegateUpdateCarInfo(carModel: carModel, carModelYear: carModelYear, carPlateInNumbers: carPlateInNumbers, carPlateInLetters: carPlateInLetters) :
            params = [
                "car_model"             : carModel,
                "manufacturing_year"    : carModelYear,
                "car_numbers"           : carPlateInNumbers,
                "car_letters"           : carPlateInLetters
            ]

        case let .changePhone(code):
            params = [
                "code": code,
            ]

        case .confirmPhoneSocialLogin(code: let code, token: _):
            params = [
                "code": code,
            ]

        case .getTicket, .wallet, .userReviews, .policy, .terms:
            return nil

        case let .singleTicket(ticketId):
            params = [
                "ticket_id": ticketId,
            ]

        case let .contactUs(name, phone, message):
            params = [
                "name": name,
                "phone": phone,
                "message": message,
            ]

        case let .notification(page):
            params = [
                "page": page,
            ]

        case let .notificationControll(notify, newOrder):
            if let notifyControll = notify, let newOrder = newOrder {
                params = [
                    "offers_notify": notifyControll,
                    "new_orders_notify": newOrder,
                ]
            }
        case let .regions(id):
            params = [
                "country_id": id,
            ]

        case let .cities(id):
            params = [
                "region_id": id,
            ]

        case let .getFavorite(page: page):
            params = [
                :
//                "page": page,
            ]

        default:
            return nil
        }

        print(params)

        return params
    }

    // MARK: - headers

    internal var headers: HTTPHeaders {
        var header = HTTPHeaders()

        let Lang = Language.apiLanguage()
        let token = defult.shared.getData(forKey: .token) ?? ""

        switch self {
        case .updateProfileSocialLogin(name: _, phoneNumber: _, countryCode: _, email: _, token: let userToken):
            header["lang"] = Lang
            header["Authorization"] = "Bearer \(userToken)"

        case .confirmPhoneSocialLogin(code: _, token: let userToken):
            header["lang"] = Lang
            header["Authorization"] = "Bearer \(userToken)"

        default:
            header["lang"] = Lang
            header["Authorization"] = "Bearer \(token)"
        }

        return header
    }

    // MARK: - Method

    internal var method: HTTPMethod {
        switch self {
        case .showProfile, .wallet, .userReviews, .policy, .terms, .getTicket, .singleTicket, .notification, .cities, .getFavorite, .nationalities ,.about,.regions ,.getCarTypes:
            return .get
        case .deleteProfile:
            return .delete
        default:
            return .post
        }
    }

    var requestURL: URL {
        let url = mainURL.appendingPathComponent(path.rawValue)
        switch self {
        default:
            break
        }

        print(url)
        return url
    }

    // MARK: - Encoding

    internal var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
