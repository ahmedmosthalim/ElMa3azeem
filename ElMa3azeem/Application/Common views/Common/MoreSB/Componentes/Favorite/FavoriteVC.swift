//
//  FavoriteVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 31/11/2022.
//

import UIKit

class FavoriteVC: BaseViewController {
    @IBOutlet weak var producrTableView: UITableView!

    @IBOutlet weak var emptyStack: UIStackView!
    @IBOutlet weak var emptyIMage: UIImageView!

    private let refreshControl = UIRefreshControl()
    var products = [Product]()
    private var isActive = true
    private var CurrentPage = 1
    private var lastPage = 1
    var isFirstResponse = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFavorite(page: CurrentPage)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - CONFIGRATION

    private func setupView() {
        tableViewConfigration()
        setupRefreshControl()
    }

    private func tableViewConfigration() {
        producrTableView.delegate = self
        producrTableView.dataSource = self
        producrTableView.registerCell(type: StoreCategoryCell.self)
    }

    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        producrTableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: AnyObject) {
        isFirstResponse = true
        getApiData()
        refreshControl.endRefreshing()
    }

    private func getApiData() {
        products.removeAll()
        CurrentPage = 1
        lastPage = 1
        getFavorite(page: CurrentPage)
    }

    // MARK: - LOGIC

    private func noDataView() {
        emptyStack.isHidden = !products.isEmpty
        emptyIMage.isHidden = !products.isEmpty
    }

    // MARK: - NAVIGATION

    func navigateToStore(product: Product) {
        let vc = AppStoryboards.NormalOrder.instantiate(StoreDetailsVC.self)
        vc.comeFromFavorite = true
        vc.product = product
        vc.storeID = product.storeId ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - ACTIONS
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - TableView Extension

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: StoreCategoryCell.self, for: indexPath) as! StoreCategoryCell

        cell.configCell(model: products[indexPath.row])
        cell.selectCategory = { [weak self] in
            guard let self = self else { return }
            self.navigateToStore(product: self.products[indexPath.row])
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
            if position > ContentHeight - producrTableView.frame.height {
                isActive = false
                print(CurrentPage, lastPage)
                if CurrentPage < lastPage {
                    CurrentPage = CurrentPage + 1
                    getFavorite(page: CurrentPage)
                }
            }
        }
    }
}

// MARK: - API

extension FavoriteVC {
    func getFavorite(page: Int) {
        showLoader()
        MoreNetworkRouter.getFavorite(page: page).send(GeneralModel<[Product]>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getFavorite(page: page)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {

                    self.products = response.data ?? []
                    self.isFirstResponse = false

                    self.isFirstResponse ? self.producrTableView.reloadWithAnimation() : self.producrTableView.reloadData()
                    self.isFirstResponse = false
                    self.isActive = true
                    
                    self.noDataView()
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}
