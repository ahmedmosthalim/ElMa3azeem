//
//  OrderProductDetailsView.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit

class OrderProductDetailsView: UIView {
    let XIB_NAME = "OrderProductDetailsView"

    // MARK: - outlets -

    @IBOutlet weak var productsTableView: IntrinsicTableView!

    private var products: [Products]?

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        tableViewConfigration()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        tableViewConfigration()
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

    private func tableViewConfigration() {
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.register(UINib(nibName: "OrderDetailsCell", bundle: nil), forCellReuseIdentifier: "OrderDetailsCell")
    }

    private func handleVisibility() {
        isHidden = products?.isEmpty ?? false
    }

    func configView(products: [Products]?) {
        self.products = products
        productsTableView.reloadData()
        handleVisibility()
    }
}

// MARK: - TableView Extension

extension OrderProductDetailsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ordderDetails = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsCell", for: indexPath) as! OrderDetailsCell
        ordderDetails.configCell(product: products?[indexPath.row])
        return ordderDetails
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
