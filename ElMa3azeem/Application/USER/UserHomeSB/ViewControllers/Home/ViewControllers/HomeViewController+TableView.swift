//
//  HomeViewController+TableView.swift
//  ElMa3azeem
//
//  Created by Mustafa Abdein on 03/01/2022.
//

import UIKit

//MARK: - TableView Extension -
extension HomeViewController : UITableViewDelegate , UITableViewDataSource , selectCategoryProtocol{
    
    func selectStoreFromHome(index: Int) {
        let id = self.homeData.first(where: {$0.category == HomeData.stores.rawValue})?.stores?[index].id ?? 0
      
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue , bundle: nil)
        //MARK: - Edit
        let vc  = storyboard.instantiateViewController(withIdentifier: "StoreDetailsVC") as! StoreDetailsVC
        vc.storeID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectCategoryCell(index: Int) {
        
        let category = self.homeData.first(where: {$0.category == HomeData.categories.rawValue})?.categories?[index]
        
        if category?.slug == "parcel_delivery" {
            let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue , bundle: nil)
            let vc  = storyboard.instantiateViewController(withIdentifier: "ParcelDeliveryVC") as! ParcelDeliveryVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if category?.slug == "special_request" {
            let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue , bundle: nil)
            let vc  = storyboard.instantiateViewController(withIdentifier: "SpecialRequestVC") as! SpecialRequestVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let category = self.homeData.first(where: {$0.category == HomeData.categories.rawValue})?.categories?[index]

            let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue , bundle: nil)
            let vc  = storyboard.instantiateViewController(withIdentifier: "StoresVC") as! StoresVC
            vc.categoryid   = "\(category?.id ?? 0)" 
            vc.viewTitle    = category?.name ?? ""
            vc.categoryNameForApi = category?.slug ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < self.homeData.count {
            guard let category = self.homeData[indexPath.row].category else {
                return UITableViewCell()
            }
            
            switch category {
            case HomeData.ads.rawValue :
                guard let adsCell = tableView.dequeueReusableCell(withIdentifier: "AdsCell", for: indexPath) as? AdsCell else {return UITableViewCell()}
                adsCell.configureAdsSlider(model: homeData.first(where: {$0.category == HomeData.ads.rawValue})?.ads ?? [])
                return adsCell
                
            case HomeData.stores.rawValue :
                let storeCell = tableView.dequeueReusableCell(withIdentifier: "MostPopularStoreCell", for: indexPath) as! MostPopularStoreCell
                storeCell.delegate = self
                let store = homeData.first(where: {$0.category == HomeData.stores.rawValue})
                
                storeCell.configureStoreCell(model: homeData.first(where: {$0.category == HomeData.stores.rawValue})?.stores ?? [], size: store?.size ?? "", type: store?.type ?? "", rows: "\(store?.rows ?? 0)")
                return storeCell
                
            case HomeData.categories.rawValue :
              
                let categoryCell = tableView.dequeueReusableCell(withIdentifier: "HomeCategoryCell", for: indexPath) as! HomeCategoryCell
                
                categoryCell.count = self.homeData.first(where: {$0.category == HomeData.categories.rawValue})?.categories?.count ?? 0
                
                let categories = homeData.first(where: {$0.category == HomeData.categories.rawValue})
                categoryCell.configureCategoryCell(model: homeData.first(where: {$0.category == HomeData.categories.rawValue})?.categories ?? [], size: categories?.size ?? "", type: categories?.type ?? "", rows: "\(categories?.rows ?? 0)")
                categoryCell.delegate = self
                return categoryCell
                
            default:
                return UITableViewCell()
            }
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
