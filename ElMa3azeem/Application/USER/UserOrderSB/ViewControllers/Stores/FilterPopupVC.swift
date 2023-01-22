//
//  FilterPopupVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 31/11/2022.
//

import BottomPopup
import UIKit

protocol FilterProtocal {
    func filter(filterData : FilterStores)
}

enum FilterStores : String{
    case all,high,low,nearst
    
    var rate : String {
        switch self {
        case .all:    return ""
        case .high:   return FilterStores.high.rawValue
        case .low:    return FilterStores.low.rawValue
        case .nearst: return FilterStores.nearst.rawValue
        }
    }
}

class FilterPopupVC: BottomPopupViewController {
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    var filter : FilterStores?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(self.view.frame.height) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.4 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.4 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }

    @IBOutlet weak var tableView: IntrinsicTableView!
    @IBOutlet weak var backGroungView: UIView!
    var delegate : FilterProtocal?

    private var filterArray = [
        FilterModel(title: "All",key: .all ,isSelected: false),
        FilterModel(title: "Nearest",key: .nearst, isSelected: false),
        FilterModel(title: "High rated",key: .high, isSelected: false),
        FilterModel(title: "Lowest rated",key: .low ,isSelected: false),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        filterArray[filterArray.firstIndex(where: {$0.key == filter}) ?? 0].isSelected = true
        tableView.reloadData()
        setupView()
    }

    func setupView() {
        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
        tableViewConfigration()
    }

    private func tableViewConfigration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
        tableView.reloadData()
    }

    @IBAction func chooseAction(_ sender: Any) {
        let filter = filterArray.first(where: {$0.isSelected == true})?.key ?? .all
        delegate?.filter(filterData: filter)
        dismiss(animated: true)
    }

    @IBAction func resetAction(_ sender: Any) {
        delegate?.filter(filterData: .all)
        dismiss(animated: true)
    }
}

// MARK: - TableView Extension

extension FilterPopupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.configCell(item: filterArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        filterArray.enumerated().forEach { index, _ in
            filterArray[index].isSelected = false
        }
        
        filterArray[indexPath.row].isSelected = true
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
