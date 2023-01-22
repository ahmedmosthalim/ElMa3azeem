//
//  SelectStoreCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 02/11/2022.
//

import UIKit
import UIKit
import Lottie
 

class SelectStoreCell: UITableViewCell {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var storeListBtn: UIButton!
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellAction: UIButton!
    
    var chooseStore : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundView.isHidden = true
        setupAnimationView()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        if Language.isArabic() {
            backGroundView.setupChatBootStyleArabic()
            animationView.setupChatBootStyleArabic()
        }else{
            backGroundView.setupChatBootStyleEnglish()
            animationView.setupChatBootStyleEnglish()
        }
    }
    
    func setupAnimationView() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1
        animationView.play(fromProgress: 0,
                           toProgress: 2,
                           loopMode: LottieLoopMode.playOnce,
                           completion: { (finished) in
            if finished {
                self.animationView.isHidden = true
                self.backGroundView.isHidden = false
            } else {
                print("Animation cancelled")
            }
        })
    }
    
    @IBAction func chooseStoreAction(_ sender: Any) {
        chooseStore?()
    }
    
    func configCell (category : String) {
        if category == "parcel_delivery"  || category == "special_request" {
            cellTitle.text = "Order details :".localized
            cellAction.setTitle("Enter your order details".localized, for: .normal)
        }else{
            cellTitle.text = "OK, where do you want to order now..?".localized
            cellAction.setTitle("store list".localized, for: .normal)
        }
    }
}
