//
//  ProductFeaturesView.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 15/11/2022.
//

import UIKit

enum ViewType {
    case features
    case additions
}

class ProductFeaturesView: UIView {
    private let XIB_NAME = "ProductFeaturesView"

    // MARK: - outlets -

    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var featuresTableView: UITableView!

    private var viewType: ViewType = .features
    private var featureArray = [Group]()
    private var additionsArray = [ProductAdditiveCategory]()

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

    private func commonInit() {
        guard let xib = Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)?.first, let viewFromXib = xib as? UIView else { return }
        viewFromXib.frame = bounds
        addSubview(viewFromXib)
    }

    private func tableViewConfigration() {
        featuresTableView.delegate = self
        featuresTableView.dataSource = self
        featuresTableView.register(UINib(nibName: "ProviderProductFeatureCell", bundle: nil), forCellReuseIdentifier: "ProviderProductFeatureCell")
    }

    // MARK: - Design -

    func configView(viewType: ViewType, model: [Group]) {
        self.viewType = viewType
        viewTitle.text = "Features".localized
        featureArray = model
        featuresTableView.reloadData()
    }

    func configView(viewType: ViewType, model: [ProductAdditiveCategory]) {
        self.viewType = viewType
        viewTitle.text = "Additions".localized
        additionsArray = model
        featuresTableView.reloadData()
    }
}

// MARK: - TableView Extension

extension ProductFeaturesView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch viewType {
        case .additions:
            return additionsArray.count
        case .features:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewType {
        case .additions:
            return additionsArray[section].productAdditives.count
        case .features:
            return featureArray.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProviderProductFeatureCell", for: indexPath) as! ProviderProductFeatureCell
        switch viewType {
        case .additions:
            cell.configCell(viewType: viewType, item: additionsArray[indexPath.section].productAdditives[indexPath.row] , category: additionsArray[indexPath.section].name)
        case .features:
            cell.configCell(viewType: viewType, item: featureArray[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
