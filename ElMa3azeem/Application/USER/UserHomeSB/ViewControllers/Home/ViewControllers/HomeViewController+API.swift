//
//  HomeViewController+API.swift
//  ElMa3azeem
//
//  Created by Mustafa Abdein on 03/01/2022.
//

import UIKit


extension HomeViewController  {
    func getHomeData(lat: String, long: String) {
        self.showLoader()
        HomeNetworkRouter.home(lat: lat, long: long).send(GeneralModel<[HomeModel]>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            self.refreshControl.endRefreshing()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getHomeData(lat: lat, long: long)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let response):
                if response.key == ResponceStatus.success.rawValue {
                    self.homeData = response.data!
                    self.HomeTableView.reloadWithAnimation()
                    if defult.shared.getData(forKey: .token) == "" || defult.shared.getData(forKey: .token) == nil {
                        
                    }else{
                        self.unSeenNotificationCountApi()
                    }
                }else{
                    self.showError(error: response.msg)
                }
            }
        }
    }
    
    func unSeenNotificationCountApi() {
        self.showLoader()
        HomeNetworkRouter.notifyCount.send(GeneralModel<UnSeenNotificationModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(_):
                break
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    defult.shared.setData(data: data.data?.numNotSeenNotifications ?? 0, forKey: .unSeenNorificationCount)
                    if data.data?.numNotSeenNotifications ?? 0 == 0 {
//                        self.notificationView.isHidden = true
                    }else{
//                        self.notificationView.isHidden = false
                    }
                    NotificationCenter.default.post(name: .reloadNotificationCount, object: nil)
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
}



