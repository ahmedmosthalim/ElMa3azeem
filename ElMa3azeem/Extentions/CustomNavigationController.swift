//
//  CustomNavigationController.swift
//  Masar Ebdaa
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import UIKit
 

class CustomNavigationController : UINavigationController, UINavigationControllerDelegate {
    
    override var childForStatusBarStyle: UIViewController? {
        visibleViewController
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
         self.delegate = self
        self.navigationController?.navigationBar.isHidden = true
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
         navigationController.view.semanticContentAttribute = UIView.isRightToLeft() ? .forceRightToLeft : .forceLeftToRight
         navigationController.navigationBar.semanticContentAttribute = UIView.isRightToLeft() ? .forceRightToLeft : .forceLeftToRight
    }
    
}

extension UIView {
    static func isRightToLeft() -> Bool {
        return UIView.appearance().semanticContentAttribute == .forceRightToLeft
    }
}


extension UINavigationController {
    var rootViewContoller : UIViewController? {
        return viewControllers.first
    }
}
