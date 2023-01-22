//
//  NormalOrderTopCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1111/2022.
//

import UIKit

class NormalOrderTopCell: UITableViewCell {

    @IBOutlet weak var imageCoverView: UIView!
    @IBOutlet weak var CellCoverImage: UIImageView!
    @IBOutlet weak var mainStoreNameLbl: UILabel!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var storeIsOpenStateLbl: UILabel!
    @IBOutlet weak var storeCategoryLbl: UILabel!
    
    @IBOutlet weak var storeIconeImage: UIImageView!
    @IBOutlet weak var storeRateLbl: UILabel!
    @IBOutlet weak var storeDistancelbl: UILabel!
    @IBOutlet weak var storeDeliveryPricelbl: UILabel!
    @IBOutlet weak var stateview: UIView!

    @IBOutlet weak var storeAddressLbl: UILabel!
    
    var didPressBack : (()->())?
    var didPressRate : (()->())?
    var didPressLocation : (()->())?
    var didPressWorkTime : (()->())?
    var didPressChangeBranch : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setupView() {
        imageCoverView.layer.cornerRadius = 12
        imageCoverView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        CellCoverImage.layer.cornerRadius = 12
        CellCoverImage.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    func configCell(model : StoreDetailsData?) {
        CellCoverImage.setImage(image: model?.cover ?? "", loading: true)
        mainStoreNameLbl.text = model?.name
        storeCategoryLbl.text = model?.categoryName
        storeNameLbl.text = model?.name
        storeState(state: model?.isOpen ?? false)
        storeDeliveryPricelbl.text = model?.deliveryPrice
        storeAddressLbl.text = model?.address
        storeIconeImage.setImage(image: model?.icon ?? "", loading: true)
        storeRateLbl.text = model?.rate
        storeDistancelbl.text = model?.distance
    }
    
    func storeState(state: Bool) {
        if state == true {
            stateview.backgroundColor = UIColor.appColor(.StoreStateOpen)
            storeIsOpenStateLbl.text = "Open".localized
        }else{
            stateview.backgroundColor = UIColor.appColor(.StoreStateClose)
            storeIsOpenStateLbl.text = "Closed".localized
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        didPressBack?()
    }
    
    @IBAction func rateAction(_ sender: Any) {
        didPressRate?()
    }
    
    @IBAction func locationAction(_ sender: Any) {
        didPressLocation?()
    }
    
    @IBAction func workTimeAction(_ sender: Any) {
        didPressWorkTime?()
    }
    
    @IBAction func changeStoreBranchAction(_ sender: Any) {
        didPressChangeBranch?()
    }
}
