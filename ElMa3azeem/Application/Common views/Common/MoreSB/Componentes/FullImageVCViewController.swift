//
//  FullImageVCViewController.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 14/11/2022.
//


import UIKit

class FullImageVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl:String?
    var imageToShow: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupStatusBar(color: .black)
        
        if let url = imageUrl {
            imageView.setImage(image: url, loading: true)
        }
        
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        
        scrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.setupStatusBar
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true)
    }
}

extension FullImageVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
