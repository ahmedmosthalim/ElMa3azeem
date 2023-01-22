//
//  ComplaintDetailsCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 13/11/2022.
//

import UIKit

class ComplaintDetailsCell: UICollectionViewCell {

    @IBOutlet weak var cellComplaintImage: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var deleteImage : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configerCell(image : UIImage , deletable : Bool? = false) {
        self.cellComplaintImage.image = image
        
        if deletable == true {
            deleteBtn.isHidden = false
        }else{
            deleteBtn.isHidden = true
        }
    }
    func configerCellWithUrl(image : String , deletable : Bool? = false) {
        self.cellComplaintImage.setImage(image: image, loading: true)
        
        if deletable == true {
            deleteBtn.isHidden = false
        }else{
            deleteBtn.isHidden = true
        }
    }
    
    func configerSelectCell(image : UIImage) {
        self.cellComplaintImage.image = image
        deleteBtn.isHidden = true
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        deleteImage?()
    }
}
