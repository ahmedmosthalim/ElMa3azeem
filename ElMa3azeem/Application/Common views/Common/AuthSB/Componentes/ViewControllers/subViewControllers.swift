//
//  subViewControllers.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 22/11/2022.
//

import UIKit

class SubViewControllers: BaseViewController {
    @IBOutlet weak var introImageView   : UIImageView!
    @IBOutlet weak var introTitleLbl    : UILabel!
    @IBOutlet weak var introDescLbl     : UILabel!

    var introImage  : String?
    var introTitle  : String?
    var introDesc   : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        introImageView.setImage(image: introImage ?? "")
        introTitleLbl.text          = introTitle ?? ""
        introTitleLbl.textColor     = .white
        introDescLbl.text           = introDesc ?? ""
        introDescLbl.textColor      = .white

        setupGradShadow()
        
    }

    static func createViewController(data: Intro) -> SubViewControllers {
        let vc = UIStoryboard(name: StoryBoard.Auth.rawValue, bundle: nil).instantiateViewController(withIdentifier: "SubViewControllers") as! SubViewControllers

        vc.introImage = data.image
        vc.introTitle = data.title
        vc.introDesc = data.desc

        return vc
    }
    
    func setupGradShadow() {
        let maskedView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        maskedView.backgroundColor = .black.withAlphaComponent(0.5)
        
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = maskedView.bounds
        
        maskedView.clipsToBounds = true
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientMaskLayer.locations = [0.0, 0.4]
        
        maskedView.layer.mask = gradientMaskLayer
        introImageView.addSubview(maskedView)
    }
}
