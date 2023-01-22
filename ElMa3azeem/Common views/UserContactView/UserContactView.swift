//
//  UserContactView.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit

class UserContactView: UIView {
    let XIB_NAME = "UserContactView"

    // MARK: - outlets -

    @IBOutlet weak var viewTitleLbl     : UILabel!
    @IBOutlet weak var delegateImage    : UIImageView!
    @IBOutlet weak var delegateNameLbl  : UILabel!
    @IBOutlet weak var phoneCallBtn     : SpaceingImageButton!
    @IBOutlet weak var chatBtn          : SpaceingImageButton!
    @IBOutlet weak var showChatBtn      : SpaceingImageButton!

    var phoneTapped: (() -> Void)?
    var chatTapped: (() -> Void)?

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
        delegateImage.makeCircularPhoto()
        delegateImage.clipsToBounds = true
    }

    func configView(delegateAvatar: String?, delegateName: String?, orderState: OrderStatus?) {
        viewTitleLbl.text = "Delivery data :".localized
        phoneCallBtn.isHidden = orderState == .finished ? true : false
//        phoneCallBtn.isHidden = false
        chatBtn.isHidden = orderState == .inTransit ? false : true
        showChatBtn.isHidden = orderState == .finished ? false : true
        delegateImage.setImage(image: delegateAvatar ?? "", loading: true)
        delegateNameLbl.text = delegateName
    }

    func configView(userAvatar: String?, userName: String?, orderState: OrderStatus?) {
        viewTitleLbl.text = "Customer data :".localized
        if defult.shared.user()?.user?.accountType != .provider {
            chatBtn     .isHidden = orderState == .inTransit ? false : true
            showChatBtn .isHidden = orderState == .finished ? false : true
        } else {
            showChatBtn.isHidden = true
            chatBtn.isHidden = true
        }
        phoneCallBtn.isHidden = orderState == .finished ? true : false
//        phoneCallBtn.isHidden = false
        delegateImage.setImage(image: userAvatar ?? "", loading: true)
        delegateNameLbl.text = userName
    }

    @IBAction func phoneAction(_ sender: Any) {
        phoneTapped?()
        print("tap@Phone")
    }

    @IBAction func chatAction(_ sender: Any) {
        chatTapped?()
        print("tap@Chat")
    }

    @IBAction func showChat(_ sender: Any) {
        chatTapped?()
        print("tap@Chat")
    }
}
