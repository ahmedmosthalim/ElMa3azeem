//
//  DelegateOrderDetailsTableViewExtension.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/01/2022.
//

import UIKit

////MARK: - TableView Extension
//extension DelegateOrderDetailsVC : UITableViewDelegate , UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch tableView {
//        case productsTableView:
//            return orderData?.order.products?.count ?? 0
//        default:
//            return 0
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch tableView {
//        case productsTableView:
//            let ordderDetails = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsCell", for: indexPath) as! OrderDetailsCell
//            ordderDetails.configCell(product: orderData?.order.products?[indexPath.row])
//            return ordderDetails
//        default:
//            return UITableViewCell()
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}
