//
//  OrderDetailsCollectionViewExtension.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2911/2022.
//

import UIKit

//MARK: - CollectionView Extension
extension UserOrderDetailsVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
//        case progressCollectionView:
//            switch orderData?.order.orderType {
//
//            case .specialStoreWithDelivery:
//                if self.orderData?.order.needsDelivery == true {
//                    return stepsSpecialStores.count
//                }else{
//                    return stepsSpecialStoresNoDelivery.count
//                }
//            case .googleStore:
//                return stepsGoogleStore.count
//
//            case .parcelDelivery:
//                return stepsParcelDelivery.count
//
//            case .specialPackage:
//                return stepsSpecialDelivery.count
//
//            case .defult:
//                return 0
//
//            case .none:
//                return 0
//
//            }
//            return 0
//        case notesImageCollectionView:
//            return orderData?.order.images?.count ?? 0
            
        case invoiceCollectionView :
            return invoiveIMages.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        switch collectionView {
//        case progressCollectionView:
            
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiristStrpProgressCell", for: indexPath) as! FiristStrpProgressCell
//
//            switch orderType {
//            case .specialStoreWithDelivery:
//                if self.orderData?.order.needsDelivery == true {
//                    cell.configeCell(title: stepsSpecialStores[indexPath.row], currenIndex: indexPath.row, lastIndex: stepsSpecialStores.count, selectedIndex: currentStateIndex)
//
//                }else{
//                    cell.configeCell(title: stepsSpecialStoresNoDelivery[indexPath.row], currenIndex: indexPath.row, lastIndex: stepsSpecialStoresNoDelivery.count, selectedIndex: currentStateIndex)
//
//                }
//
//            case .googleStore:
//                cell.configeCell(title: stepsGoogleStore[indexPath.row], currenIndex: indexPath.row, lastIndex: stepsGoogleStore.count, selectedIndex: currentStateIndex)
//
//
//            case .parcelDelivery:
//                cell.configeCell(title: stepsParcelDelivery[indexPath.row], currenIndex: indexPath.row, lastIndex: stepsParcelDelivery.count, selectedIndex: currentStateIndex)
//
//
//            case .specialPackage:
//                cell.configeCell(title: stepsSpecialDelivery[indexPath.row], currenIndex: indexPath.row, lastIndex: stepsSpecialDelivery.count, selectedIndex: currentStateIndex)
//
//
//            case .defult:
//                fatalError()
//
//            case .none:
//                fatalError()
//
//            }
//
//            return UICollectionViewCell()
            
//        case notesImageCollectionView:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComplaintDetailsCell", for: indexPath) as! ComplaintDetailsCell
//
//            cell.configerCellWithUrl(image: orderData?.order.images?[indexPath.row].url ?? "")
//            return cell
            
        case invoiceCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComplaintDetailsCell", for: indexPath) as! ComplaintDetailsCell
            
            cell.configerCellWithUrl(image: invoiveIMages[indexPath.row].url, deletable: false)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComplaintDetailsCell", for: indexPath) as! ComplaintDetailsCell
            
            cell.configerCell(image: UIImage(named: "logo")!)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
//        case progressCollectionView:
//            return 0
        default :
            return 10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
//        case progressCollectionView:
//            return 0
        default :
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
//        case notesImageCollectionView:
//            showFullScreen(url: orderData?.order.images?[indexPath.row].url ?? "")
//            
        case invoiceCollectionView:
            showFullScreen(url: orderData?.order.invoiceImage ?? "")
        default :
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
//        case progressCollectionView:
//            var count = 0
//            switch orderData?.order.orderType {
//            case .specialStoreWithDelivery: count = self.orderData?.order.needsDelivery == true ? stepsSpecialStores.count : stepsSpecialStoresNoDelivery.count
//            case .googleStore: count = stepsGoogleStore.count
//            case .parcelDelivery: count = stepsSpecialStores.count
//            case .specialPackage: count = stepsSpecialDelivery.count
//            case .defult: break
//            case .none: break
//            }
//
//            let width = collectionView.frame.width / CGFloat(count)
//            return CGSize(width: width, height: collectionView.frame.height)
//
        default:
            return CGSize(width: 90, height: 90)
        }
    }
} 
