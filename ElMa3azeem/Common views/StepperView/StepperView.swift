//
//  StoreDetailsView.swift
//  Fast order
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 21/11/2022.
//

import UIKit
protocol StepperDalegate {
    func setStepperTitlesForItems(titles: [String])
    func setStepperViewImages(nextStateImage: UIImage?, currentStateImage: UIImage?, finishedStateImage: UIImage?)
    func setStepperLabelsColor(activeColor: UIColor, notActiceColor: UIColor)
    func setStepperLinesColor(activeColor: UIColor, notActiceColor: UIColor)
    func setStepperCurrentIndex(toIndex: Int)
    func setStepperFinishedState()
    func setStepperCancelState()
}


public class StepperView: UIView {
    @IBOutlet weak var stepperCollectionView: UICollectionView!

    private var isFinished: Bool? = false
    private var currentIndex: Int? = 0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.stepperCollectionView.reloadData()
            }
        }
    }

    private var titels: [String]? = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                self.stepperCollectionView.reloadData()
            }
        }
    }

    private var nextStateImage          : UIImage?
    private var currentStateImage       : UIImage?
    private var finishedStateImage      : UIImage?
    private var activeLineColor         : UIColor = .red
    private var notActiveLineColor      : UIColor = .yellow
    private var activeTitleStepperColor : UIColor = .red
    private var notActiveTitleColor     : UIColor = .yellow

    let XIB_NAME = "StepperView"

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        collectionViewConfigration()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        collectionViewConfigration()
    }

    private func commonInit() {
        guard let xib = Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)?.first, let viewFromXib = xib as? UIView else { return }
        viewFromXib.frame = bounds
        addSubview(viewFromXib)
    }

    // MARK: - SETUP

    private func collectionViewConfigration() {
        stepperCollectionView.delegate = self
        stepperCollectionView.dataSource = self
        stepperCollectionView.register(UINib(nibName: "StepItemCell", bundle: nil), forCellWithReuseIdentifier: "StepItemCell")
        stepperCollectionView.reloadData()
    }

    // MARK: - LOGIC

    public func getCurrentIndex() -> Int {
        return currentIndex ?? 0
    }
}

extension StepperView: StepperDalegate {
    public func setStepperLinesColor(activeColor: UIColor, notActiceColor: UIColor) {
        activeLineColor = activeColor
        notActiveLineColor = notActiceColor
    }
    
    public func setStepperLabelsColor(activeColor: UIColor, notActiceColor: UIColor) {
        activeTitleStepperColor = activeColor
        notActiveTitleColor = notActiceColor
    }
    
    public func setStepperFinishedState() {
        isFinished = true
    }

    public func setStepperCurrentIndex(toIndex: Int) {
        currentIndex = toIndex
    }

    public func setStepperTitlesForItems(titles: [String]) {
        titels = titles
    }

    public func setStepperViewImages(nextStateImage: UIImage?, currentStateImage: UIImage?, finishedStateImage: UIImage?) {
        self.nextStateImage = nextStateImage
        self.currentStateImage = currentStateImage
        self.finishedStateImage = finishedStateImage
    }

    public func allupdate() {
        stepperCollectionView.reloadData()
    }
    
    public func setStepperCancelState(){
        self.isHidden = true
    }
}

extension StepperView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titels?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StepItemCell", for: indexPath) as! StepItemCell
        
        cell.configUI(activeLineColor: activeLineColor, notActiveLineColor: notActiveLineColor, activeTitleStepperColor: activeTitleStepperColor, notActiveTitleColor: notActiveTitleColor, nextStateImage: nextStateImage, currentStateImage: currentStateImage, finishedStateImage: finishedStateImage)

        cell.configeCell(title: titels?[indexPath.row] ?? "", currenIndex: indexPath.row, lastIndex: titels?.count ?? 0, selectedIndex: currentIndex ?? 0 , isFinished: isFinished)

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / CGFloat(titels?.count ?? 0)
        return CGSize(width: width, height: collectionView.frame.height)
    }
}
