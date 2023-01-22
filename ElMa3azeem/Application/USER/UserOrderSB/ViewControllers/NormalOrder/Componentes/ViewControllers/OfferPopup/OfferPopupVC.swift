//
//  OfferPopupVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1311/2022.
//

import UIKit

class OfferPopupVC: UIViewController {

    @IBOutlet weak var offerImage: UIImageView!
    var imageUrl = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAnimate()
        self.offerImage.setImage(image: imageUrl, loading: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.removeAnimate()
    }
}
