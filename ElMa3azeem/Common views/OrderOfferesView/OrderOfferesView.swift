//
//  OrderOfferesView.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit

class OrderOfferesView: UIView {
    let XIB_NAME = "OrderOfferesView"

    // MARK: - outlets -

    @IBOutlet weak var offresTableView: IntrinsicTableView!

    private var deliveryOffers: [OrderOfferModel]?

    var userAcceiptOfferTapped: ((Int) -> Void)?
    var userRejectOfferTapped: ((Int, IndexPath) -> Void)?

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Design -

    private func commonInit() {
        guard let xib = Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)?.first, let viewFromXib = xib as? UIView else { return }
        viewFromXib.frame = bounds
        addSubview(viewFromXib)
    }

    private func registerTableViewCells() {
        offresTableView.delegate = self
        offresTableView.dataSource = self
        offresTableView.register(UINib(nibName: "offresCell", bundle: nil), forCellReuseIdentifier: "offresCell")
    }

    private func handleVisibility() {
        isHidden = deliveryOffers?.isEmpty ?? false
    }

    func configView(deliveryOffers: [OrderOfferModel]?) {
        self.deliveryOffers = deliveryOffers
        offresTableView.reloadData()

        handleVisibility()
    }

    func reloadView(index: IndexPath) {
        deliveryOffers?.remove(at: index.row)
        offresTableView.deleteRows(at: [index], with: .automatic)
    }
}

// MARK: - TableView Extension

extension OrderOfferesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryOffers?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let offerCell = tableView.dequeueReusableCell(withIdentifier: "offresCell", for: indexPath) as! offresCell

        offerCell.configCell(offer: deliveryOffers?[indexPath.row])

        // accept offer action
        offerCell.acceptOffer = { [weak self] in
            guard let self = self else { return }
            self.userAcceiptOfferTapped?(self.deliveryOffers?[indexPath.row].id ?? 0)
        }

        // reject offer action
        offerCell.rejectOffer = { [weak self] in
            guard let self = self else { return }
            self.userRejectOfferTapped?(self.deliveryOffers?[indexPath.row].id ?? 0, indexPath)
        }

        return offerCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
