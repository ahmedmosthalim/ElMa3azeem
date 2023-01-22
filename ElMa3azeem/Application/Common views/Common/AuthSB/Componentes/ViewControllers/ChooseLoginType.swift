//
//  ChooseLoginType.swift
//  ElMa3azeem
//
//  Created by Ahmed Mostafa on 13/11/2022.
//

import Foundation

class ChooseLoginType : BaseViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    
    @IBAction func navigateToUserLogin(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoard.Auth.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.accountTypeForLogin = "user"
        self.navigationController!.pushViewController(vc, animated: true)
    }
    @IBAction func navigateToProviderLogin(_ sender: Any) {
        let vc = AppStoryboards.Auth.instantiate(LoginViewController.self)
        vc.accountTypeForLogin = "provider"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func navigateToDelegateLogin(_ sender: Any) {
        let vc = AppStoryboards.Auth.instantiate(LoginViewController.self)
        vc.accountTypeForLogin = "delegate"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
