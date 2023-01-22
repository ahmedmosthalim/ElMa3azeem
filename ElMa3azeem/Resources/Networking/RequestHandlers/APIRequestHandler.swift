//
//  APIManager.swift
//  SwiftCairo-App
//
//  Created by abdelrahman mohamed on 1/29/18.
//  Copyright © 2018 abdelrahman mohamed. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import FBSDKLoginKit

/// Response completion handler beautified.
typealias CallResponse<T> = ((Result<T, Error>) -> Void)?


/// API protocol, The alamofire wrapper
protocol APIRequestHandler: HandleAlamoResponse {
}

extension APIRequestHandler where Self: URLRequestBuilder {
    
    func send<T: CodableInit>(_ decoder: T.Type, data: [UploadData]? = nil, progress: ((Progress) -> Void)? = nil, then: CallResponse<T>) {
        
        if let data = data {
            uploadToServerWith(decoder, data: data, request: self, parameters: self.parameters, progress: progress, then: then)
        }else{
            AF.request(self).validate().responseData {(response) in
                self.handleResponse(response, completion: then)
            }.responseJSON { (response) in
                // handle debug
                
                let json = JSON(response.data as Any)
                _ = json["key"].stringValue
                let code = json["code"].intValue
                let userStatus = json["user_status"].stringValue
                _ = json["msg"].stringValue
                
                printApiResponse(response.data)
                
                if code == 419 {
                    resetApp()
                }else if code == 401 && userStatus == UserState.pending.rawValue||userStatus == UserState.block.rawValue {
                    resetApp()
                }
                
//                print(" 🆁🅴🆂🅿🅾🅽🆂🅴 \(json)")
            }
        }
    }
    
    func cancelRequest() -> Void {
        let sessionManager = Session.default
        sessionManager.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.first(where: { $0.originalRequest?.url == self.requestURL})?.cancel()
            uploadTasks.first(where: { $0.originalRequest?.url == self.requestURL})?.cancel()
            downloadTasks.first(where: { $0.originalRequest?.url == self.requestURL})?.cancel()
        }
    }
    
    func resetApp() {
        if let root = UIApplication.shared.keyWindow?.rootViewController as? CustomNavigationController {
            let currentVC = root.visibleViewController
            if currentVC?.isKind(of: ConfirmCodeViewController.self) == false {
                backToLogin()
            }
        }else{
            guard let root = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController else{return}
            let home = root.viewControllers?[0] as! HomeNavigationController
            root.selectedIndex = 0
            root.navigationController?.popToRootViewController(animated: true)
            let currentVC = home.visibleViewController
            if currentVC?.isKind(of: ConfirmCodeViewController.self) == false {
                backToLogin()
            }
        }
    }

    func backToLogin() {
        let language = Language.currentLanguage()
        SocketConnection.sharedInstance.socket.disconnect()
        UserDefaults.standard.removeObject(forKey: "token")
        defult.shared.removeAll()
        let mangare = LoginManager()
        mangare.logOut()

        Language.setAppLanguage(lang: language)
        defult.shared.setData(data: false, forKey: .isFiristLuanch)
        
        let vc = AppStoryboards.Auth.instantiate(ChooseLoginType.self)
        let nav = CustomNavigationController(rootViewController: vc)
        MGHelper.changeWindowRoot(vc: nav)
    }
}



extension APIRequestHandler {
    
    private func uploadToServerWith<T: CodableInit>(_ decoder: T.Type, data: [UploadData], request: URLRequestConvertible, parameters: Parameters?, progress: ((Progress) -> Void)?, then: CallResponse<T>) {
        
        AF.upload(multipartFormData: { mul in
            for d in data{
                mul.append(d.data, withName: d.name, fileName: d.fileName, mimeType: d.mimeType)
            }
            guard let parameters = parameters else { return }
            for (key, value) in parameters {
                mul.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
        }, with: request).responseData { results in
            self.handleResponse(results, completion: then)
        }.responseString { string in
            debugPrint(string.value as Any)
            
            let json = JSON(string.data!)
            _ = json["key"].stringValue
            let code = json["code"].intValue
            let userStatus = json["user_status"].stringValue
            _ = json["msg"].stringValue
            
            
            printApiResponse(string.data)
            
            if code == 419 {
                resetApp()
            }else if code == 401 && userStatus == UserState.pending.rawValue||userStatus ==  UserState.block.rawValue {
                resetApp()
            }
//            print(" 🆁🅴🆂🅿🅾🅽🆂🅴 \(json)")
        }
    }
    
    func resetApp() {
        if let root = UIApplication.shared.keyWindow?.rootViewController as? CustomNavigationController {
            let currentVC = root.visibleViewController
            if currentVC?.isKind(of: ConfirmCodeViewController.self) == false {
                backToLogin()
            }
        }else{
            guard let root = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController else{return}
            let home = root.viewControllers?[0] as! HomeNavigationController
            root.selectedIndex = 0
            root.navigationController?.popToRootViewController(animated: true)
            let currentVC = home.visibleViewController
            if currentVC?.isKind(of: ConfirmCodeViewController.self) == false {
                backToLogin()
            }
        }
    }

    func backToLogin() {
        let language = Language.currentLanguage()
        SocketConnection.sharedInstance.socket.disconnect()
        UserDefaults.standard.removeObject(forKey: "token")
        defult.shared.removeAll()
        let mangare = LoginManager()
        mangare.logOut()

        Language.setAppLanguage(lang: language)
        defult.shared.setData(data: false, forKey: .isFiristLuanch)
        
        let vc = AppStoryboards.Auth.instantiate(LoginViewController.self)
//        let nav = CustomNavigationController(rootViewController: vc)
        MGHelper.changeWindowRoot(vc: vc)
    }
    
}

class networkManager {
    
    static let Shared = networkManager()
    
    func GetAPI(url:String , Parameters params:[String:Any]? , Compelition:@escaping (Data?, Error?) -> Void) {
        guard let URL = URL(string: url) else { return}
        
        AF.request(URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: [:])
            .validate(statusCode:200...300)
            .responseJSON { (response) in
                
                switch response.result {
                case .success(let value):
                    print(value)
                    let data = response.data
                    Compelition(data,nil)
                    
                case .failure(let error):
                    
                    print(error.localizedDescription)
                    Compelition(nil,error)
                }
            }
    }
}


func handleResponse<T: Codable>(_ response: AFDataResponse<Any>, completion: @escaping (_ respons: T?, _ errorType: RouterErrors?) -> Void) {
    switch response.result {
    case .failure:
        completion(nil, .connectionError)
    case let .success(value):
        do {
            let decoder = JSONDecoder()
            let jsonData = try? JSONSerialization.data(withJSONObject: value)
            let valueObject = try decoder.decode(T.self, from: jsonData!)
            completion(valueObject, nil)
        } catch let DecodingError.keyNotFound(key, context) {
            Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
            completion(nil, .canNotDecodeData)
        } catch let DecodingError.valueNotFound(type, context) {
            Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
            completion(nil, .canNotDecodeData)
        } catch let DecodingError.typeMismatch(type, context) {
            Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
            completion(nil, .canNotDecodeData)
        } catch let DecodingError.dataCorrupted(context) {
            Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
            completion(nil, .canNotDecodeData)
        } catch let error as NSError {
            NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
            completion(nil, .canNotDecodeData)
        }
    }
}

enum RouterErrors: String {
    case connectionError
    case canNotDecodeData
}

func printApiResponse(_ responseData: Data?) {
    guard let responseData = responseData else {
        print("\n\n====================================\n⚡️⚡️RESPONSE IS::\n", responseData as Any, "\n====================================\n\n")
        return
    }

    if let object = try? JSONSerialization.jsonObject(with: responseData, options: []),
       let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted, .sortedKeys]), let JSONString = String(data: data, encoding: String.Encoding.utf8) {
        print("\n\n====================================\n⚡️⚡️RESPONSE IS::\n", JSONString, "\n====================================\n\n")
        return
    }
    print("\n\n====================================\n⚡️⚡️RESPONSE IS::\n", responseData, "\n====================================\n\n")
}
