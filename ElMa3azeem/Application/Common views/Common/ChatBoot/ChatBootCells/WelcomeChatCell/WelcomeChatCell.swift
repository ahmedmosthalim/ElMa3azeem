//
//  WelcomeChatCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 02/11/2022.
//

import UIKit
import Lottie
 

class WelcomeChatCell: UITableViewCell {
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var animationView: LottieAnimationView!
    
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
    
    func configCell(userName:String) {
        messageLbl.text = "\("Good evening".localized) \(userName) ☺️"
    }
}
