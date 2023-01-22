//
//  ResponseHandler.swift
//  SwiftCairo-App
//
//  Created by abdelrahman mohamed on 4/21/18.
//  Copyright © 2018 abdelrahman mohamed. All rights reserved.
//

import UIKit
import Alamofire

protocol HandleAlamoResponse {
    /// Handles request response, never called anywhere but APIRequestHandler
    ///
    /// - Parameters:
    ///   - response: response from network request, for now alamofire Data response
    ///   - completion: completing processing the json response, and delivering it in the completion handler
    func handleResponse<T: CodableInit>(_ response: AFDataResponse<Data>, completion: CallResponse<T>)
}

extension HandleAlamoResponse {
    
    func handleResponse<T: CodableInit>(_ response: AFDataResponse<Data>, completion: CallResponse<T>) {
        switch response.result {
        case .failure(let error):
            if response.response?.statusCode == nil {
                completion?(.failure(APIConnectionErrors.connection))
            } else {
                completion?(.failure(error))
            }
        case .success(let value):
            
            //EDIT
//            do {
//                let modules = try T(data: value)
//                completion?(.success(modules))
//            } catch {
//                completion?(.failure(error))
//            }
            
            do {
                let modules = try T(data: value)
                completion?(.success(modules))
            } catch let DecodingError.keyNotFound(key, context) {
                Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
            } catch let DecodingError.valueNotFound(type, context) {
                Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
            } catch let DecodingError.typeMismatch(type, context) {
                Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
            } catch let DecodingError.dataCorrupted(context) {
                Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
            } catch let error as NSError {
                NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                completion?(.failure(error))
            }
        }
    }
    
}

enum APIConnectionErrors: Error {
    case connection
}
