//
//  WorkTimePopupVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1311/2022.
//

import UIKit
import BottomPopup

class WorkTimePopupVC : BottomPopupViewController {
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    override var popupHeight: CGFloat { return height ?? CGFloat(self.view.frame.height) }
    override var popupTopCornerRadius: CGFloat { return topCornerRadius ?? CGFloat(10) }
    override var popupPresentDuration: Double { return presentDuration ?? 0.4 }
    override var popupDismissDuration: Double { return dismissDuration ?? 0.4 }
    override var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? true }
    
    @IBOutlet weak var backViewHight: NSLayoutConstraint!
    @IBOutlet weak var backGroungView: UIView!
    @IBOutlet weak var wortTimeTableView: IntrinsicTableView!
    
    var timesArray = [OpeningHour]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {

        wortTimeTableView.tableFooterView = UIView()
        wortTimeTableView.delegate = self
        wortTimeTableView.dataSource = self
        wortTimeTableView.register(UINib(nibName: "WorkTimeCell", bundle: nil), forCellReuseIdentifier: "WorkTimeCell")
        self.wortTimeTableView.reloadWithAnimation()
        
        backGroungView.layer.cornerRadius = 32
        backGroungView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
        backGroungView.clipsToBounds = true
        
        if (wortTimeTableView.contentSize.height + 50) > (UIScreen.main.bounds.height * 0.85) {
            self.backViewHight.constant = self.wortTimeTableView.contentSize.height + 50
        } else {
            self.wortTimeTableView.isScrollEnabled = true
            self.backViewHight.constant = CGFloat(self.view.frame.height * 0.85)
        }
        self.viewDidLayoutSubviews()
    }
}

//MARK: - TableView Extension -
extension WorkTimePopupVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkTimeCell", for: indexPath) as! WorkTimeCell
        cell.configeCell(day: timesArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

