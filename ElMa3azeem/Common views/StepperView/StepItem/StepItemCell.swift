//
//  FiristStrpProgressCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 02/01/2022.
//

import UIKit

class StepItemCell: UICollectionViewCell {
    @IBOutlet weak var progressImage    : UIImageView!
    @IBOutlet weak var progressTitle    : UILabel!
    @IBOutlet weak var leftLine         : UIView!
    @IBOutlet weak var rightLine        : UIView!

    private var activeLineColor         : UIColor = .red
    private var notActiveLineColor      : UIColor = .yellow
    private var activeTitleStepperColor : UIColor = .red
    private var notActiveTitleColor     : UIColor = .yellow

    private var nextStateImage          : UIImage?
    private var currentStateImage       : UIImage?
    private var finishedStateImage      : UIImage?

    private var isFinished              : Bool? = false

    override func awakeFromNib() {
        super.awakeFromNib()
        progressImage.backgroundColor = .appColor(.viewBackGround)
    }

    func configUI(activeLineColor: UIColor, notActiveLineColor: UIColor, activeTitleStepperColor: UIColor, notActiveTitleColor: UIColor, nextStateImage: UIImage?, currentStateImage: UIImage?,finishedStateImage: UIImage?) {
        self.activeLineColor         = activeLineColor
        self.notActiveLineColor      = notActiveLineColor
        self.activeTitleStepperColor = activeTitleStepperColor
        self.notActiveTitleColor     = notActiveTitleColor
        self.nextStateImage          = nextStateImage
        self.currentStateImage       = currentStateImage
        self.finishedStateImage      = finishedStateImage
    
    }

    func configeCell(title: String, currenIndex: Int, lastIndex: Int, selectedIndex: Int, isFinished: Bool? = false) {
        if isFinished == true {
            finishedState(title: title)
        } else {
            if currenIndex < selectedIndex {
                finishedState(title: title)
            }else if currenIndex == selectedIndex {
                currentState(title: title)
            }else if currenIndex > selectedIndex {
                nextState(title: title)
            }
        }
        
        if currenIndex == 0 {
            leftLine.removeDashLine()
        } else if lastIndex - 1 == currenIndex {
            rightLine.removeDashLine()
        }
    }
    
    func finishedState(title: String) {
        leftLine.createDashedLine(color: activeLineColor)
        rightLine.createDashedLine(color: activeLineColor)
        progressTitle.text = title
        progressTitle.textColor = activeTitleStepperColor
        progressImage.image = finishedStateImage
//            progressImage.layer.shadowRadius = 1
//            progressImage.layer.shadowOpacity = 0.5
//            progressImage.layer.shadowOffset = CGSize(width: 0, height: 3)
//            progressImage.layer.shadowColor = activeLineColor.withAlphaComponent(0.5).cgColor
    }

    func currentState(title: String) {
        leftLine.createDashedLine(color: activeLineColor)
        rightLine.createDashedLine(color: notActiveLineColor)
        
        progressTitle.text      = title
        progressTitle.textColor = activeTitleStepperColor
        progressImage.image     = currentStateImage
//
//            progressImage.layer.shadowRadius = 0.5
//            progressImage.layer.shadowOpacity = 0.3
//            progressImage.layer.shadowOffset = CGSize(width: 0, height: 2)
//            progressImage.layer.shadowColor = UIColor.black.withAlphaComponent(0.20).cgColor
    }

    func nextState(title: String) {
        leftLine.createDashedLine(color: notActiveLineColor)
        rightLine.createDashedLine(color: notActiveLineColor)
        
        progressTitle.text = title
        progressTitle.textColor = notActiveTitleColor
        progressImage.image = nextStateImage
    }

}
