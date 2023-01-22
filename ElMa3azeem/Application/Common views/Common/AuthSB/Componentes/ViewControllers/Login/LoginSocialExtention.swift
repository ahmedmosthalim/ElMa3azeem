//
//  LoginSocialExtention.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 26/01/2022.
//
import LocalAuthentication
import AuthenticationServices
import UIKit
import FBSDKLoginKit

//MARK: -  Apple Login
extension LoginViewController : ASAuthorizationControllerDelegate  , ASAuthorizationControllerPresentationContextProviding {
    func setUpSignInAppleButton() {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
        authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        authorizationButton.clipsToBounds = true
        authorizationButton.layer.cornerRadius = 20
        self.socailStackView.addArrangedSubview(authorizationButton)
    }
    
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    //MARK: -  handle delegate-
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let firstName = appleIDCredential.fullName?.givenName ?? ""
            let lastName = appleIDCredential.fullName?.familyName ?? ""
            let fullName = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
            let email = appleIDCredential.email ?? ""
            
            print(" userIdentifier : \(userIdentifier) ,fullName : \(firstName) \(lastName) ,email : \(email) ")
            
            self.loginSocial(socialID: userIdentifier, name: fullName , email: email)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
           return self.view.window!
    }
}


//MARK: - FaceBook login

extension LoginViewController :  LoginButtonDelegate{
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let _ = result?.token?.tokenString else{
            print("Facebook login error: \(error?.localizedDescription ?? "")")
            return
        }
        showUserInfoFromFacebook()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func showUserInfoFromFacebook() {
        GraphRequest(graphPath: "/me", parameters: ["fields" : "id, email, name"]).start { [weak self] (connection, result, error) in
            guard let self = self else {return}
            print(result as Any)
            
            guard let result = result as? [String:Any] else{return}
            print(result)
            let name = result["name"] as? String
            let email = result["email"] as? String
            let id = result["id"] as? String
            
            self.loginSocial(socialID: id ?? "", name: name ?? "", email: email ?? "")
        }
    }
}
