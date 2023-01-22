//
//  CancelReasonView.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 06/11/2022.
//

import UIKit

class CancelReasonView: UIView {
    private let XIB_NAME = "CancelReasonView"

    // MARK: - outlets -

    @IBOutlet weak var cancelReasonView: UILabel!

    private var cancelReasone: String = ""

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    deinit {
        print("\(NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "XIB") is deinit, No memory leak found")
    }

    // MARK: - Design -

    private func commonInit() {
        guard let xib = Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)?.first, let viewFromXib = xib as? UIView else { return }
        viewFromXib.frame = bounds
        addSubview(viewFromXib)
    }

    private func handleVisibility() {
        isHidden = cancelReasone == ""
    }

    func configView(reason: String?) {
        cancelReasone = reason ?? ""
        cancelReasonView.text = reason
        handleVisibility()
    }
}
