//
//  extensionUIVIewControllerSwiftMessage.swift
//  Masar Ebdaa
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import Foundation
import SwiftMessages

extension UIViewController {
    
    func showMessage(title: String? = nil, sub: String?, type: Theme = .warning, layout: MessageView.Layout = .statusLine) {
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: layout)
        
        // Theme message elements with the warning style.
        view.configureTheme(type)
        view.button?.isHidden = true
        // Add a drop shadow.
        //        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        
        view.configureContent(title: title ?? "", body: sub ?? "", iconText: "" )
        
        // add Configuration for view
        let config = SwiftMessages.Config()
        // change font
        view.titleLabel?.font = UIFont(name: "Sukar Bold", size: 16)
        view.bodyLabel?.font = UIFont(name: "Sukar Regular", size: 14)
        
        // Show the message.
        SwiftMessages.show(config: config, view: view)
    }
    
}

func show(title: String? = nil, sub: String?, type: Theme = .warning, layout: MessageView.Layout = .statusLine) {
    // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
    // files in the main bundle first, so you can easily copy them into your project and make changes.
    let view = MessageView.viewFromNib(layout: layout)
    
    // Theme message elements with the warning style.
    view.configureTheme(type)
    view.button?.isHidden = true
    // Add a drop shadow.
    //        view.configureDropShadow()
    
    // Set message title, body, and icon. Here, we're overriding the default warning
    // image with an emoji character.
    
    view.configureContent(title: title ?? "", body: sub ?? "", iconText: "" )
    
    // add Configuration for view
    let config = SwiftMessages.Config()
    // change font
    view.titleLabel?.font = UIFont(name: "Sukar Bold", size: 16)!
    view.bodyLabel?.font = UIFont(name: "Sukar Regular", size: 14)!
    
    // Show the message.
    SwiftMessages.show(config: config, view: view)
}
