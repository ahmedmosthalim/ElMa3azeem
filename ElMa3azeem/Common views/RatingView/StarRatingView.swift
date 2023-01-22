//
//  StarRatingView.swift
//
//  Created by Guido on 7/1/20.
//  Copyright © applified.life - All rights reserved.
//

import UIKit

public enum StarRounding: Int {
    case roundToHalfStar = 0
    case ceilToHalfStar = 1
    case floorToHalfStar = 2
    case roundToFullStar = 3
    case ceilToFullStar = 4
    case floorToFullStar = 5
}

@IBDesignable
class StarRatingView: UIView {
    @IBInspectable var rating: Float = 0 {
        didSet {
            setStarsFor(rating: rating)
        }
    }

    @IBInspectable var starColor: UIColor = UIColor.systemOrange {
        didSet {
            for starImageView in [hstack?.star1ImageView, hstack?.star2ImageView, hstack?.star3ImageView, hstack?.star4ImageView, hstack?.star5ImageView] {
                starImageView?.tintColor = starColor
            }
        }
    }

    var starRounding: StarRounding = .roundToHalfStar {
        didSet {
            setStarsFor(rating: rating)
        }
    }

    @IBInspectable var starRoundingRawValue: Int {
        get {
            return starRounding.rawValue
        }
        set {
            starRounding = StarRounding(rawValue: newValue) ?? .roundToHalfStar
        }
    }

    fileprivate var hstack: StarRatingStackView?

    fileprivate let fullStarImage: UIImage = UIImage(systemName: "star.fill")!
    fileprivate let halfStarImage: UIImage = UIImage(systemName: "star.leadinghalf.filled")!
    fileprivate let emptyStarImage: UIImage = UIImage(systemName: "star")!

    convenience init(frame: CGRect, rating: Float, color: UIColor, starRounding: StarRounding) {
        self.init(frame: frame)
        setupView(rating: rating, color: color, starRounding: starRounding)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(rating: rating, color: starColor, starRounding: starRounding)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView(rating: 0, color: UIColor.systemOrange, starRounding: .roundToHalfStar)
    }

    fileprivate func setupView(rating: Float, color: UIColor, starRounding: StarRounding) {
        let bundle = Bundle(for: StarRatingStackView.self)
        let nib = UINib(nibName: "StarRatingStackView", bundle: bundle)
        let viewFromNib = nib.instantiate(withOwner: self, options: nil)[0] as! StarRatingStackView
        addSubview(viewFromNib)

        viewFromNib.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[v]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: ["v": viewFromNib]
            )
        )
        addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[v]|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil, views: ["v": viewFromNib]
            )
        )

        hstack = viewFromNib
        self.rating = rating
        starColor = color
        self.starRounding = starRounding

        isMultipleTouchEnabled = false
        hstack?.isUserInteractionEnabled = false
    }

    fileprivate func setStarsFor(rating: Float) {
        let starImageViews = [hstack?.star1ImageView, hstack?.star2ImageView, hstack?.star3ImageView, hstack?.star4ImageView, hstack?.star5ImageView]
        for i in 1 ... 5 {
            let iFloat = Float(i)
            switch starRounding {
            case .roundToHalfStar:
                starImageViews[i - 1]!.image = rating >= iFloat - 0.25 ? fullStarImage :
                    (rating >= iFloat - 0.75 ? halfStarImage : emptyStarImage)
            case .ceilToHalfStar:
                starImageViews[i - 1]!.image = rating > iFloat - 0.5 ? fullStarImage :
                    (rating > iFloat - 1 ? halfStarImage : emptyStarImage)
            case .floorToHalfStar:
                starImageViews[i - 1]!.image = rating >= iFloat ? fullStarImage :
                    (rating >= iFloat - 0.5 ? halfStarImage : emptyStarImage)
            case .roundToFullStar:
                starImageViews[i - 1]!.image = rating >= iFloat - 0.5 ? fullStarImage : emptyStarImage
            case .ceilToFullStar:
                starImageViews[i - 1]!.image = rating > iFloat - 1 ? fullStarImage : emptyStarImage
            case .floorToFullStar:
                starImageViews[i - 1]!.image = rating >= iFloat ? fullStarImage : emptyStarImage
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches began")
        guard let touch = touches.first else { return }
        touched(touch: touch, moveTouch: false)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched moved")
        guard let touch = touches.first else { return }
        touched(touch: touch, moveTouch: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched ended")
        guard let touch = touches.first else { return }
        touched(touch: touch, moveTouch: false)
    }

    var lastTouch: Date?
    fileprivate func touched(touch: UITouch, moveTouch: Bool) {
        guard !moveTouch || lastTouch == nil || lastTouch!.timeIntervalSince(Date()) < -0.1 else { return }
        print("processing touch")

        guard let hs = hstack else { return }
        let touchX = Language.isArabic() ? (hs.frame.width - touch.location(in: hs).x) : touch.location(in: hs).x
        let ratingFromTouch = 5 * touchX / hs.frame.width
        var roundedRatingFromTouch: Float!
        switch starRounding {
        case .roundToHalfStar, .ceilToHalfStar, .floorToHalfStar:
            roundedRatingFromTouch = Float(round(2 * ratingFromTouch) / 2)
        case .roundToFullStar, .ceilToFullStar, .floorToFullStar:
            roundedRatingFromTouch = Float(round(ratingFromTouch))
        }
        rating = roundedRatingFromTouch
        lastTouch = Date()
    }
}
