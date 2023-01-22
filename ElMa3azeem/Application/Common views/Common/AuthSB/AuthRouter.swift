//
//  AuthRouter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 26/11/2022.
//

import Alamofire
import Foundation

enum AuthRouter: URLRequestBuilder {
    case intro
    case country
    case login(phone: String, country_key: String)
    case delegateLogin(phone: String, country_key: String)
    case storeLogin(phone: String, country_key: String)
    case activeCode(code: String, token: String)
    case resendCode(phone: String, token: String)
    case completeInto(email: String, name: String, phone: String, token: String)
    case socialLogin(socialID: String, name: String, email: String, token: String)

    // MARK: - Paths

    internal var path: ServiceURL {
        switch self {
        case .intro:
            return .intro
        case .country:
            return .countries
        case .login:
            return .userLogin
        case .delegateLogin :
            return .delegateLogin
        case .storeLogin :
            return .storeLogin
        case .activeCode:
            return .activeCode
        case .resendCode:
            return .resendCode
        case .completeInto:
            return .completeData
        case .socialLogin:
            return .socialLogin
        }
    }

    // MARK: - Parameters

    internal var parameters: Parameters? {
        var params = Parameters()

        switch self {
        case .intro, .country:
            return nil
        case let .login(phone: phone, country_key: country_key):
            params = [
                "phone": phone,
                "country_key": country_key,
                "device_id": AppDelegate.FCMToken,
                "device_type": "ios",
            ]
        case let .delegateLogin(phone: phone, country_key: country_key):
            params = [
                "phone": phone,
                "country_key": country_key,
                "device_id": AppDelegate.FCMToken,
                "device_type": "ios",
            ]
        case let .storeLogin(phone: phone, country_key: country_key):
            params = [
                "phone": phone,
                "country_key": country_key,
                "device_id": AppDelegate.FCMToken,
                "device_type": "ios",
            ]
        case .activeCode(code: let code, token: _):
            params = [
                "code": code,
            ]
        case .resendCode(phone: let phone, token: _):
            params = [
                "phone": phone,
            ]
        case .completeInto(email: let email, name: let name, phone: let phone, token: _):
            params = [
                "name": name,
                "phone": phone,
                "email": email,
            ]

        case .socialLogin(socialID: let id, name: let name, email: let mail, token: _):
            params = [
                "social_id": id,
                "name": name,
                "device_id": AppDelegate.FCMToken,
                "device_type": "ios",
                "email": mail,
            ]
        }

        return params
    }

    // MARK: - headers

    internal var headers: HTTPHeaders {
        var header = HTTPHeaders()

        var Lang = Language.apiLanguage()
        let token = defult.shared.getData(forKey: .token) ?? ""

        switch self {
        case .activeCode(code: _, token: let token):
            header["lang"] = Lang
            header["Authorization"] = "Bearer \(token)"

        case .resendCode(phone: _, token: let token):
            header["lang"] = Lang
            header["Authorization"] = "Bearer \(token)"

        case .completeInto(email: _, name: _, phone: _, token: let token):
            header["lang"] = Lang
            header["Authorization"] = "Bearer \(token)"

        case .socialLogin( _, _, _, _):
            header["lang"] = Lang
//            header["Authorization"] = "Bearer \(token)"

        default:
            header["lang"] = Lang
            header["Authorization"] = "Bearer \(token)"
        }
        return header
    }

    // MARK: - Method

    internal var method: HTTPMethod {
        switch self {
        case .intro, .country:
            return .get
        default:
            return .post
        }
    }
}
