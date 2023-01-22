//
//  ProviderAddNewBranchTimesVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 07/11/2022.
//

import CoreLocation
import UIKit

class ProviderAddNewBranchTimesVC: BaseViewController {
    // MARK: - OutLets

    @IBOutlet weak var viewTitleLbl             : UILabel!
    @IBOutlet weak var timesTableView           : UITableView!
    @IBOutlet weak var synchTimeImageView       : UIImageView!
    @IBOutlet weak var synchTimeInfoImageView   : UIImageView!

    // MARK: - Variables

    var branchData: StoreDetailsData?
    var branchBackup: ((StoreDetailsData, Bool) -> Void)?
    var screenReason: ScreenReason = .addNew
    var activeSyenchTime = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        branchBackup?(branchData!, activeSyenchTime)
    }

    // MARK: - CONFIGRATION

    private func setupView() {
        tableViewConfigration()
        setupGestures()

        switch screenReason {
        case .addNew:
            viewTitleLbl.text = "Add new branch".localized
        case .edit:
            viewTitleLbl.text = "Edit branch".localized
        }

        if activeSyenchTime {
            activesynchTime()
        } else {
            DeactivesynchTime()
        }

        timesTableView.reloadData()
    }

    private func setupGestures() {
        synchTimeImageView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.didTapActiveSynchTime()
        }

        synchTimeInfoImageView.addTapGesture { [weak self] in
            guard let self = self else { return }
            self.didTapActiveSynchTimeInfo()
        }
    }

    @objc func didTapActiveSynchTime() {
        activeSyenchTime = !activeSyenchTime

        if activeSyenchTime {
            activesynchTime()
        } else {
            DeactivesynchTime()
        }
    }

    @objc func didTapActiveSynchTimeInfo() {
        showSyenchTimeInfoPopup()
    }

    private func tableViewConfigration() {
        timesTableView.delegate = self
        timesTableView.dataSource = self
        timesTableView.registerCell(type: StoreWorkTimeCell.self)
        timesTableView.reloadWithAnimation()
    }

    // MARK: - LOGIC

    private func activesynchTime() {
        synchTimeImageView?.image = UIImage(named: "squar_check_mark_selected-1") ?? UIImage()
        branchData?.openingHours = defult.shared.provider()?.openingHours ?? []
        print(defult.shared.provider()?.openingHours ?? [])
        timesTableView?.reloadWithAnimation()
    }

    private func DeactivesynchTime() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.synchTimeImageView?.image = UIImage(named: "providerCheckMark") ?? UIImage()
            self.timesTableView?.reloadWithAnimation()
        }
    }

    // MARK: - NAVIGATION

    private func showSyenchTimeInfoPopup() {
        let vc = AppStoryboards.ProviderMore.instantiate(SyenchTimeInfoVC.self)
        vc.modalPresentationStyle = .fullScreen
        addChild(vc)
        vc.view.frame = view.frame
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    private func showBranchAddedSuccessfully() {
        let vc = AppStoryboards.Order.instantiate(SuccessfullyViewPopupVC.self)
        switch screenReason {
        case .addNew:
            vc.titleMessage = .addBranchSuccessfully
        case .edit:
            vc.titleMessage = .updateBranchSuccessfully
        }

        vc.backToHome = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToViewController(ofClass: ProviderStoreBranchesVC.self)
        }
        present(vc, animated: true, completion: nil)
    }

    // MARK: - ACTIONS

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addBranchAction(_ sender: Any) {
        var dayes = [ApiDayModel]()
        for day in branchData?.openingHours ?? [] {
            if day.fromTime ?? Date() > day.toTime ?? Date() {
                showError(error: "Please confirm all start time must be before the closing time.".localized)
                return
            }

            dayes.append(ApiDayModel(days: day.key ?? "", from: day.apiFrom, to: day.apiTo))
        }

        switch screenReason {
        case .addNew:
            addBranch(location: CLLocationCoordinate2D(latitude: Double(branchData?.lat ?? "") ?? 0.0, longitude: Double(branchData?.long ?? "") ?? 0.0), address: branchData?.address ?? "", countryKey: branchData?.countryCode ?? "", phone: branchData?.branchPhone ?? "", email: branchData?.branchEmail ?? "", haveMasterBranchTimes: activeSyenchTime, workTimes: dayes.toString())
        case .edit:
            updateBranch(id: branchData?.id ?? 0, location: CLLocationCoordinate2D(latitude: Double(branchData?.lat ?? "") ?? 0.0, longitude: Double(branchData?.long ?? "") ?? 0.0), address: branchData?.address ?? "", countryKey: branchData?.countryCode ?? "", phone: branchData?.branchPhone ?? "", email: branchData?.branchEmail ?? "", haveMasterBranchTimes: activeSyenchTime, workTimes: dayes.toString())
        }
    }
}

// MARK: - TableView Extension

extension ProviderAddNewBranchTimesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (branchData?.openingHours.count ?? 0) + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: StoreWorkTimeCell.self, for: indexPath) as! StoreWorkTimeCell

        if indexPath.row == 0 {
            cell.configFiristCell()
        } else {
            cell.configCell(time: branchData?.openingHours[indexPath.row - 1])
        }

        cell.addTimeTapped = { [weak self] day, fromTime, toTime in
            guard let self = self else { return }

//            if (self.branchData?.openingHours.first(where: { $0.id == day.pickerId })) != nil {
//                self.showError(error: "This day was added before".localized)
//            } else {
            self.branchData?.openingHours.append(OpeningHour(id: day.pickerId, key: day.pickerKey, day: day.pickerTitle, from: fromTime, to: toTime))
            self.branchData?.openingHours.sort(by: { $0.id ?? 0 < $1.id ?? 0 })
            tableView.reloadData()
//            }
        }

        cell.deleteTimeTapped = { [weak self] in
            guard let self = self else { return }
            self.branchData?.openingHours.remove(at: indexPath.row - 1)
            tableView.reloadData()
        }

        cell.errorSelecting = { [weak self] errorMessage in
            guard let self = self else { return }
            self.showError(error: errorMessage)
        }

        cell.updateDay = { [weak self] selectedDay in
            guard let self = self else { return }
            if indexPath.row > 0 {
                if (self.branchData?.openingHours.first(where: { $0.id == selectedDay.pickerId })) != nil {
                    self.showError(error: "This day was added before".localized)
                } else {
                    self.branchData?.openingHours[indexPath.row - 1].id = selectedDay.pickerId
                    self.branchData?.openingHours[indexPath.row - 1].day = selectedDay.pickerTitle
                    self.branchData?.openingHours[indexPath.row - 1].key = selectedDay.pickerKey

                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        cell.updateFromDate = { [weak self] fromTime in
            guard let self = self else { return }
            if indexPath.row > 0 {
                self.branchData?.openingHours[indexPath.row - 1].fromTime = fromTime
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        cell.updateToDate = { [weak self] toTime in
            guard let self = self else { return }
            if indexPath.row > 0 {
                self.branchData?.openingHours[indexPath.row - 1].toTime = toTime
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
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

extension ProviderAddNewBranchTimesVC {
    func addBranch(location: CLLocationCoordinate2D, address: String, countryKey: String, phone: String, email: String, haveMasterBranchTimes: Bool, workTimes: String) {
        showLoader()
        ProviderMoreRouter.addNewBranch(location: location, address: address, countryKey: countryKey, phone: phone, email: email, haveMasterBranchTimes: haveMasterBranchTimes, workTimes: workTimes).send(GeneralModel<StoreDetailsData>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.addBranch(location: location, address: address, countryKey: countryKey, phone: phone, email: email, haveMasterBranchTimes: haveMasterBranchTimes, workTimes: workTimes)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.showBranchAddedSuccessfully()
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func updateBranch(id: Int, location: CLLocationCoordinate2D, address: String, countryKey: String, phone: String, email: String, haveMasterBranchTimes: Bool, workTimes: String) {
        showLoader()
        ProviderMoreRouter.updateBranch(branchID: id, location: location, address: address, countryKey: countryKey, phone: phone, email: email, haveMasterBranchTimes: haveMasterBranchTimes, workTimes: workTimes).send(GeneralModel<StoreDetailsData>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.updateBranch(id: id, location: location, address: address, countryKey: countryKey, phone: phone, email: email, haveMasterBranchTimes: haveMasterBranchTimes, workTimes: workTimes)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.showSuccess(title: "", massage: "Congratulations!\n Branch updated successfully.".localized)
                    self.navigationController?.popToViewController(ofClass: ProviderStoreBranchesVC.self)
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}
