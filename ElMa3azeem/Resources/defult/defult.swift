//
//  defult.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/11/2022.
//

import Foundation

enum userDefaultsNames: String {
    case isFiristLuanch
    case fromLogin
    case firstLogin
    case token
    case user
    case appLanguage
    case userLat
    case userLong
    case userAddress
    case appCurrency
    case unSeenNorificationCount
    case provider
    case appCurrencyAr
    case appCurrencyEn
}


class defult {
    static let shared = defult()

    func setData(data: Any, forKey: userDefaultsNames) {
        UserDefaults.standard.setValue(data, forKey: forKey.rawValue)
    }

    func getData(forKey: userDefaultsNames) -> String? {
        return UserDefaults.standard.string(forKey: forKey.rawValue)
    }

    func getDataInt(forKey: userDefaultsNames) -> Int? {
        return UserDefaults.standard.integer(forKey: forKey.rawValue)
    }

    func getDataBool(forKey: userDefaultsNames) -> Bool? {
        return UserDefaults.standard.bool(forKey: forKey.rawValue)
    }

    func getAppCurrency() -> String? {
        return Language.isArabic() ? UserDefaults.standard.string(forKey: userDefaultsNames.appCurrencyAr.rawValue) : UserDefaults.standard.string(forKey: userDefaultsNames.appCurrencyEn.rawValue)
    }

    func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
    }

    func user() -> UserModel? {
        if let decoded = UserDefaults.standard.object(forKey: userDefaultsNames.user.rawValue) as? Data {
            if let decodedData = try? JSONDecoder().decode(UserModel.self, from: decoded) {
                return decodedData
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func saveUser(user: UserModel?) {
        do {
            let encoded = try JSONEncoder().encode(user)
            UserDefaults.standard.set(encoded, forKey: userDefaultsNames.user.rawValue)

        } catch {
            print("can't encode")
        }
    }

    func provider() -> StoreDetailsData? {
        if let decoded = UserDefaults.standard.object(forKey: userDefaultsNames.provider.rawValue) as? Data {
            if let decodedData = try? JSONDecoder().decode(StoreDetailsData.self, from: decoded) {
                return decodedData
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    func saveProvider(provider: StoreDetailsData?) {
        do {
            let encoded = try JSONEncoder().encode(provider)
            UserDefaults.standard.set(encoded, forKey: userDefaultsNames.provider.rawValue)

        } catch {
            print("can't encode")
        }
    }
}

final class KeychainHelper {
    static let standard = KeychainHelper()
    private init() {}

    func save(_ data: Data, service: String, account: String) {
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary

        // Add data in query to keychain
        let status = SecItemAdd(query, nil)

        if status != errSecSuccess {
            // Print out the error
            print("Error: \(status)")
        }
    }
}

func uupdate(_ data: Data, service: String, account: String) {
    // Create query
    let query = [
        kSecValueData: data,
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account,
    ] as CFDictionary

    // Add data in query to keychain
    let status = SecItemAdd(query, nil)

    if status == errSecDuplicateItem {
        // Item already exist, thus update it.
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary

        let attributesToUpdate = [kSecValueData: data] as CFDictionary

        // Update existing item
        SecItemUpdate(query, attributesToUpdate)
    }
}
