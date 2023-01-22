//
//  ChooseFromMenuBootCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit
import UIKit
import Lottie
 

class ChooseFromMenuBootCell: UITableViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var storeListBtn: UIButton!
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellAction: UIButton!
    
    var chooseFromMenu : (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundView.isHidden = true
        setupAnimationView()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupView() {
        
        if Language.isArabic() {
            backGroundView.setupChatBootStyleArabic()
            animationView.setupChatBootStyleArabic()
        }else{
            backGroundView.setupChatBootStyleEnglish()
            animationView.setupChatBootStyleEnglish()
        }
        
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
        chooseFromMenu?()
    }
}
