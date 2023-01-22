//
//  extensionUIViewController.swift
//  Masar Ebdaa
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

import AVKit
import FBSDKLoginKit
import IQKeyboardManagerSwift
import Kingfisher
import UIKit

extension UIViewController {
    var storyboardId: String {
        return value(forKey: "storyboardIdentifier") as! String
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        // KeyboardAvoiding.avoidingView = view
        view.endEditing(true)
    }

    func restartApp(inStoryboard storyboard: StoryBoard, withIdentifier identifier: String) {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: identifier) as! CustomNavigationController
        VC.navigationBar.isHidden = true
        UIApplication.shared.delegate?.window??.rootViewController = VC
    }

    enum mediaTypes: String {
        case publicImage = "public.image"
        case publicMovie = "public.movie"
    }

    func Takephoto(forSourseTybe source: UIImagePickerController.SourceType, types: [String], fromViewController viewController: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = source
            imagePicker.allowsEditing = true
            imagePicker.mediaTypes = types
            imagePicker.modalPresentationStyle = .automatic
            present(imagePicker, animated: true, completion: nil)
        }
    }

    func setupStatusBar(color: UIColor) {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            let topPadding = window?.safeAreaInsets.top
            let statusbarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: topPadding ?? 0.0))
            statusbarView.backgroundColor = color
            statusbarView.tag = 1
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.addSubview(statusbarView)
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.tag = 1
            statusBar?.backgroundColor = color
        }
        
    }

    func removeStatusBarColor() {
        let subviewArray = UIApplication.shared.windows.first?.subviews
        for view in subviewArray! {
            if view.tag == 1 {
                view.removeFromSuperview()
            }
        }
    }

    func uploadImage(mediaType: [String]) {
        let alert = UIAlertController(title: "Choose photo".localized, message: "", preferredStyle: .actionSheet)
        alert.overrideUserInterfaceStyle = .dark
        alert.addAction(UIAlertAction(title: "Camera".localized, style: .default, handler: { _ in
            self.Takephoto(forSourseTybe: .camera, types: mediaType, fromViewController: self)
        }))
        alert.addAction(UIAlertAction(title: "Photos".localized, style: .default, handler: { _ in
            self.Takephoto(forSourseTybe: .photoLibrary, types: mediaType, fromViewController: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?
            .rootViewController?.present(alert, animated: true, completion: nil)
    }

    func showAnimate() {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        })
    }

    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0

        }, completion: { (finished: Bool) in
            if finished {
                self.view.removeFromSuperview()
            }
        })
    }

    func openMaps(latitude: Double, longitude: Double, title: String?) {
        let application = UIApplication.shared
        let coordinate = "\(latitude),\(longitude)"
        let encodedTitle = title?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let handlers = [
            ("Google Maps", "comgooglemaps://?q=\(coordinate)"),
            ("Apple Maps", "http://maps.apple.com/?q=\(encodedTitle)&ll=\(coordinate)"),
            ("Waze", "waze://?ll=\(coordinate)"),
            ("Citymapper", "citymapper://directions?endcoord=\(coordinate)&endname=\(encodedTitle)"),
        ]
        .compactMap { name, address in URL(string: address).map { (name, $0) } }
        .filter { _, url in application.canOpenURL(url) }

        guard handlers.count > 1 else {
            if let (_, url) = handlers.first {
                application.open(url, options: [:])
            }
            return
        }
        let alert = UIAlertController(title: "R.string.localizable.select_map_app()", message: nil, preferredStyle: .actionSheet)
        handlers.forEach { name, url in
            alert.addAction(UIAlertAction(title: name, style: .default) { _ in
                application.open(url, options: [:])
            })
        }
        alert.addAction(UIAlertAction(title: "R.string.localizable.cancel()", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func logout() {
        guard let window = UIApplication.shared.keyWindow else { return }

        let sb = UIStoryboard(name: StoryBoard.Auth.rawValue, bundle: nil)
        var vc: UIViewController

        vc = sb.instantiateViewController(withIdentifier: "CustomNavigationController")

        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .showHideTransitionViews, animations: nil, completion: nil)
    }

    func generateQRCode(from string: String, image: UIImageView) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: image.frame.width, y: image.frame.height)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }

    func videoSnapshot(filePathLocal: String) -> UIImage? {
        let vidURL = NSURL(fileURLWithPath: filePathLocal as String)
        let asset = AVURLAsset(url: vidURL as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)

        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
