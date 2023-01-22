//
//  ProviderMyProductsVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 25/11/2022.
//

import UIKit

class ProviderMyProductsVC: BaseViewController {
    @IBOutlet weak var productsTableView    : UITableView!
    @IBOutlet weak var searchTf             : UITextField!

    @IBOutlet weak var emptyImage           : UIImageView!
    @IBOutlet weak var emptyStack           : UIStackView!
    @IBOutlet weak var searchIcon           : UIImageView!
    @IBOutlet weak var searchContainerView  : AppTextFieldViewStyle!

    var productsArray   = [ProviderProductData]()
    let refreshControl  = UIRefreshControl()

    var isActive    = true
    var CurrentPage = 1
    var lastPage    = 1
    var searchText  = ""

    var isFromChatBoot = false
    var selectedStore: ((_ store: Store) -> Void)?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.showTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        tabBarController?.delegate = self
        searchTf.delegate = self
        setupView()
        setupGesture()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateData()
    }

    // MARK: - Configration

    func updateData() {
        CurrentPage = 1
        lastPage = 1
        productsArray.removeAll()
        getMyProducts(page: CurrentPage, search: searchText)
    }

    private func setupView() {
        tableViewConfigration()
        
        searchIcon.addTapGesture { [weak self] in
            guard let self = self else {return}
            self.cancelAction()
        }
    }

    private func setupGesture() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        productsTableView.addSubview(refreshControl)
    }

    @objc func refresh(_ sender: AnyObject) {
        updateData()
        refreshControl.endRefreshing()
    }

    private func tableViewConfigration() {
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.register(UINib(nibName: "StoreCategoryCell", bundle: nil), forCellReuseIdentifier: "StoreCategoryCell")
    }

    private func searchEnabled() {
        searchContainerView.layer.borderColor = UIColor.appColor(.StoreStateClose)!.cgColor
        searchContainerView.layer.borderWidth = 1
        searchIcon.image = UIImage(systemName: "xmark")
        searchIcon.tintColor = UIColor.appColor(.StoreStateClose)!
    }

    private func searchNotEnabled() {
        searchContainerView.borderColor = .clear
        searchContainerView.layer.borderWidth = 0
        searchIcon.image = UIImage(named: "search-icon")
    }
    
    @objc func cancelAction() {
        searchNotEnabled()
        searchTf.text = ""
        searchText = ""

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchAction(_:)), object: nil)
        perform(#selector(searchAction), with: nil, afterDelay: 0.5)
    }

    // MARK: - Navigations

    func navigateToProduct(productID: Int) {
        let storyboard = UIStoryboard(name: StoryBoard.ProviderProduct.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProviderProductDetailsVC") as! ProviderProductDetailsVC
        vc.productID = productID
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - ACTION

    @IBAction func AddProductAction(_ sender: Any) {
        let vc = AppStoryboards.ProviderProduct.instantiate(ProviderAddProductVC.self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notificationButtonPressed(_ sender: UIButton) {
        let vc = AppStoryboards.More.instantiate(NotificationVC.self)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - textField delegate

extension ProviderMyProductsVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchText = textField.text ?? ""
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchAction(_:)), object: nil)
        perform(#selector(searchAction), with: nil, afterDelay: 0.5)
    }

    @objc func searchAction(_ textField: UITextField) {
        if searchText.isEmpty == false {
            searchEnabled()
        } else {
            searchNotEnabled()
        }

        updateData()
    }
}

// MARK: - TableView Extension

extension ProviderMyProductsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCategoryCell", for: indexPath) as! StoreCategoryCell

        if indexPath.row < productsArray.count {
            cell.configCell(model: productsArray[indexPath.row])
            cell.selectCategory = { [weak self] in
                guard let self = self else { return }
                self.navigateToProduct(productID: self.productsArray[indexPath.row].id)
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
            if position > ContentHeight - productsTableView.frame.height {
                print("Done")
                isActive = false
                print(CurrentPage, lastPage)
                if CurrentPage < lastPage {
                    CurrentPage = CurrentPage + 1
                    getMyProducts(page: CurrentPage, search: searchText)
                }
            }
        }
    }
}

extension ProviderMyProductsVC {
    func getMyProducts(page: Int, search: String) {
        showLoader()
        ProviderHomeNetworkRouter.myProduct(page: page, searchText: search).send(GeneralModel<ProviderProductModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getMyProducts(page: page, search: search)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    if response.data?.products.isEmpty ?? false {
                        self.productsTableView.isHidden = true
                        self.emptyImage.isHidden = false
                        self.emptyStack.isHidden = false
                    } else {
                        self.productsTableView.isHidden = false
                        self.emptyImage.isHidden = true
                        self.emptyStack.isHidden = true

                        self.productsArray.append(contentsOf: response.data?.products ?? [])
                        if self.CurrentPage == 1 {
                            self.productsTableView.reloadWithAnimation()
                        } else {
                            self.productsTableView.reloadData()
                        }
                    }
                    self.CurrentPage = response.data?.pagination.currentPage ?? 0
                    self.lastPage = response.data?.pagination.totalPages ?? 0
                    self.isActive = true
                } else {
                    self.showError(error: response.msg)
                }
            }
        }
    }
}
