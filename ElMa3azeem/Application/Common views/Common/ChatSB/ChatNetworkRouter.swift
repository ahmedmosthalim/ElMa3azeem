//
//  ChatNetworkRouter.swift
//  ElMa3azeem
//
//  Created by Mustafa Abdein on 16/01/2022.
//

import Foundation
import Alamofire
 

enum ChatNetworkRouter: URLRequestBuilder {
    
    case room(room_id:Int,page:Int)
    
    case uploadFile(type:String,duration:String)
    
    // MARK: - Paths
    internal var path: ServiceURL {
        switch self {
        case .room:
            return .room
        case .uploadFile:
            return .uploadFile
        }
    }
    
    // MARK: - Parameters
    internal var parameters: Parameters? {
        var params = Parameters()
        switch self {
        case .room(room_id: let room_id,page: let page):
            params = ["room_id" : room_id ,
                      "page":page]
            
        case .uploadFile(let type,let duration):
            params = ["type" : type,
                      "duration":duration]
        }
        print(params)
        return params
    }
    
    // MARK: - headers
    internal var headers: HTTPHeaders{
        var header = HTTPHeaders()
        
        var Lang = Language.apiLanguage()
        let token = defult.shared.getData(forKey: .token) ?? ""
        print("token: \(token)")
        
        switch self {
            
        default :
            header["lang"] = Lang
            header["Authorization"] = "Bearer \(token)"
            
        }
        
        return header
    }
    
    // MARK: - Method
    internal var method: HTTPMethod {
        switch self {
        case .room:
            return .get
        default:
            return .post
        }
    }
    
    // MARK: - URL
    var requestURL : URL {
        let url = mainURL.appendingPathComponent(path.rawValue)
        switch self {
        default :
            break
        }
        
        print(url)
        return url
    }
    
    // MARK: - Encoding
    internal var encoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
}

