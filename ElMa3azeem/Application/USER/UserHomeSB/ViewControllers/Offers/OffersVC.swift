//
//  OffersVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import UIKit

class OffersVC: BaseViewController {
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var emptyStack: UIStackView!
    @IBOutlet weak var offersTableView: UITableView!

    let refreshControl = UIRefreshControl()

    private var isActive = true
    private var CurrentPage = 1
    private var lastPage = 1

    var storesArray = [Store]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.showTabbar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getOfferrs(page: CurrentPage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        tableViewConfigration()

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        offersTableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: AnyObject) {
        storesArray.removeAll()
        CurrentPage = 1
        lastPage = 1
        getOfferrs(page: CurrentPage)
        refreshControl.endRefreshing()
    }

    private func tableViewConfigration() {
        offersTableView.delegate = self
        offersTableView.dataSource = self
        offersTableView.register(UINib(nibName: "SingleStoresCell", bundle: nil), forCellReuseIdentifier: "SingleStoresCell")
    }

    private func hideNoData() {
//        offersTableView.isHidden = false
        emptyImage.isHidden = true
        emptyStack.isHidden = true
    }

    private func showNoData() {
//        offersTableView.isHidden = true
        emptyImage.isHidden = false
        emptyStack.isHidden = false
    }

    // MARK: - NAVIGATION
    func navigateToStore(storeID: Int) {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StoreDetailsVC") as! StoreDetailsVC
        vc.storeID = storeID
        navigationController?.pushViewController(vc, animated: true)
    }

    
    // MARK: - ACTION
    @IBAction func notificationButtonPressed(_ sender: UIButton) {
        let vc = AppStoryboards.More.instantiate(NotificationVC.self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - TableView Extension

extension OffersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleStoresCell", for: indexPath) as! SingleStoresCell

        cell.configeCell(store: storesArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        navigateToStore(storeID: storesArray[indexPath.row].id ?? 0)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let ContentHeight = scrollView.contentSize.height

        if isActive {
            if position > ContentHeight - offersTableView.frame.height {
                print("Done")
                isActive = false
                print(CurrentPage, lastPage)
                if CurrentPage < lastPage {
                    CurrentPage = CurrentPage + 1
                    getOfferrs(page: CurrentPage)
                }
            }
        }
    }
}

extension OffersVC {
    func getOfferrs(page: Int) {
        showLoader()
        HomeNetworkRouter.getOffers(page: page).send(GeneralModel<StoreModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getOfferrs(page: page)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    if !(response.data?.stores.isEmpty ?? false) {
                        self.hideNoData()
                        self.storesArray = response.data?.stores ?? []

                        self.lastPage = response.data?.pagination?.totalPages ?? 0

                        if self.isActive == false {
                            self.offersTableView.reloadData()
                        } else {
                            self.offersTableView.reloadWithAnimation()
                        }

                        self.isActive = true
                    } else {
                        DispatchQueue.main.async {
                            self.showNoData()
                        }
                    }

                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}
