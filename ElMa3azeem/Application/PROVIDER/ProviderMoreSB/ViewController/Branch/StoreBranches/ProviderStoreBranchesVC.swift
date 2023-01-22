//
//  StoreBranchesVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit

class ProviderStoreBranchesVC: BaseViewController {
    @IBOutlet weak var branchesTableView        : UITableView!
    @IBOutlet weak var emptyImage               : UIImageView!
    @IBOutlet weak var emptyStack               : UIStackView!

    private let refreshControl                  = UIRefreshControl()
    private var branches                        : [Branch] = []
    private var isFirstResponse                 = true
    private var isActive                        = true
    private var CurrentPage = 1
    private var lastPage = 1

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getApiData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - CONFIGRATION

    private func tableViewConfigration() {
        branchesTableView.delegate = self
        branchesTableView.dataSource = self
        branchesTableView.registerCell(type: ProviderBranchCell.self)
    }

    private func setupView() {
        tableViewConfigration()
        setupRefreshControl()
    }

    private func getApiData() {
        branches.removeAll()
        CurrentPage = 1
        lastPage = 1
        getStoreBranches(page: CurrentPage)
    }

    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        branchesTableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: AnyObject) {
        isFirstResponse = true
        getApiData()
        refreshControl.endRefreshing()
    }

    // MARK: - NAVIGATION

    private func showSuccessfulyDeletePopup() {
        let vc = AppStoryboards.ProviderMore.instantiate(SuccessDeleteBranchVC.self)
        vc.backTapped = {
            [weak self] in
            guard let self = self else { return }
            self.getApiData()
        }
        present(vc, animated: true)
    }

    private func showDeleteBranchPopup(branchId: Int) {
        let vc = AppStoryboards.ProviderMore.instantiate(DeleteBranchVC.self)
        vc.delete = { [weak self] in
            guard let self = self else { return }
            self.deleteBranch(id: branchId)
        }
        present(vc, animated: true)
    }

    private func navigateToAddBranch() {
        let vc = AppStoryboards.ProviderMore.instantiate(ProviderAddNewBranchVC.self)
        vc.screenReason = .addNew
        navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToEditBranch(branchID: Int) {
        let vc = AppStoryboards.ProviderMore.instantiate(ProviderAddNewBranchVC.self)
        vc.screenReason = .edit
        vc.branchID = branchID
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - ACTIONS

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func AddNewBranche(_ sender: Any) {
        navigateToAddBranch()
    }
}

// MARK: - TableView Extension

extension ProviderStoreBranchesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: ProviderBranchCell.self, for: indexPath) as! ProviderBranchCell
        if !branches.isEmpty {
            cell.configCell(branch: branches[indexPath.row])

            cell.editBranchTapped = { [weak self] in
                guard let self = self else { return }
                self.navigateToEditBranch(branchID: self.branches[indexPath.row].id)
            }

            cell.deleteBranchTapped = { [weak self] in
                guard let self = self else { return }
                self.showDeleteBranchPopup(branchId: self.branches[indexPath.row].id)
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let ContentHeight = scrollView.contentSize.height

        if isActive {
            if position > ContentHeight - branchesTableView.frame.height {
                print("Done")
                isActive = false
                if CurrentPage < lastPage {
                    CurrentPage = CurrentPage + 1
                    getStoreBranches(page: CurrentPage)
                }
            }
        }
    }
}

extension ProviderStoreBranchesVC {
    func getStoreBranches(page: Int) {
        showLoader()
        ProviderMoreRouter.getBranches(page: page).send(GeneralModel<BranchesModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getStoreBranches(page: page)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    if response.data?.branches.isEmpty ?? false {
                        self.branchesTableView.isHidden = true
                        self.emptyImage.isHidden = false
                        self.emptyStack.isHidden = false
                    } else {
                        self.branchesTableView.isHidden = false
                        self.emptyImage.isHidden = true
                        self.emptyStack.isHidden = true
                        self.branches.append(contentsOf: response.data?.branches ?? [])
                        self.isFirstResponse ? self.branchesTableView.reloadWithAnimation() : self.branchesTableView.reloadData()
                        self.CurrentPage = response.data?.pagination?.currentPage ?? 0
                        self.lastPage = response.data?.pagination?.totalPages ?? 0
                        self.isFirstResponse = false
                        self.isActive = true
                    }
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }

    func deleteBranch(id: Int) {
        showLoader()
        ProviderMoreRouter.deleteBranch(branchId: id).send(GeneralModel<UserModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.deleteBranch(id: id)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.showSuccessfulyDeletePopup()
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}
