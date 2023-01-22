//
//  OnBoardingInteractor.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation

 class AboutUsInteractor {
     func getIntro(completion : @escaping (GeneralModel<OnBoardingModel>?, Error?) -> ()) {
         
         var data : CallResponse<GeneralModel<OnBoardingModel>> {
             return {[weak self] (response) in
                 print(" 🆁🅴🆂🅿🅾🅽🆂🅴 \(response)")
                 switch response {
                 case .failure(let error):
                     completion(nil, error)
                 case .success(let items):
                     completion(items, nil)
                 }
             }
         }
         AuthRouter.intro.send(GeneralModel<OnBoardingModel>.self, then: data)
     }

 }
