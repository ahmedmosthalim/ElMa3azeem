//
//  HomePresenter.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 26/11/2022.
//

import Foundation


protocol HomeSliderCellView {
    func configureAdsSlider(model : [Ad])
}

protocol HomeStoreCellView {
    func configureStoreCell(model : [Store] , size : String , type:String , rows : String)
}

protocol HomeCategotyCellView {
    func configureCategoryCell(model : [Category] , size : String , type:String , rows : String)
}

protocol StoreSliderCellView {
    func setImage(url:String)
    func setStoreName(name:String)
    func setStoreCategory(category:String)
    func setRate(rate : String)
    func setDistance(dist : String)
    func storeState(state : Bool)
}

protocol ImageSliderCellView {
    func setImage(url:String)
    func setIcon(url:String)
    func setTitle(name:String)
    func setDescription(desc:String)
}

protocol CategoryCellView{
    func setImage(url:String)
    func setTitle(name:String)
}
