//
//  MoreInteractor.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import Foundation

 class MoreInteractor {
     func getProofile(completion : @escaping (GeneralModel<UserModel>?, Error?) -> ()) {
         
         var data : CallResponse<GeneralModel<UserModel>> {
             return {[weak self] (response) in
                 switch response {
                 case .failure(let error):
                     completion(nil, error)
                 case .success(let items):
                     completion(items, nil)
                 }
             }
         }
         MoreNetworkRouter.showProfile.send(GeneralModel<UserModel>.self, then: data)
     }
 }
