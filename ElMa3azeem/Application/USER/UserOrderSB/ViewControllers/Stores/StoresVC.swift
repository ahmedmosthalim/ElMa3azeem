//
//  StoresVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 2111/2022.
//

import IQKeyboardManagerSwift
import UIKit

class StoresVC: BaseViewController {
    
    // MARK: Category View
    
    @IBOutlet weak var categoryCollectionView   : UICollectionView!
    @IBOutlet weak var categoryView             : UIView!

    //MARK: TableView
    
    @IBOutlet weak var storesTableView          : UITableView!
    
    // MARK: - MainView
    
    @IBOutlet weak var viewTitleLbl             : UILabel!
    @IBOutlet weak var searchTf                 : UITextField!

    @IBOutlet weak var emptyImage               : UIImageView!
    @IBOutlet weak var emptyStack               : UIStackView!
    @IBOutlet weak var searchIcon               : UIImageView!
    @IBOutlet weak var searchContainerView      : AppTextFieldViewStyle!
    @IBOutlet weak var filterView               : AppTextFieldViewStyle!
    
    var items: [SubCategory] = []
    var viewTitle = String()
    var categoryNameForApi = String()
    var categoryid = String()
    var storeArray = [Store]()
    let refreshControl = UIRefreshControl()
    var selectedCategotyIndex   = 0
    
//    var categoryId : String?
    var categoryName : String?

    private var isActive = true
    private var CurrentPage = 1
    private var lastPage = 1
    private var searchText = ""
    private var filter : FilterStores? = .all {
        didSet{
            if filter == .all {
                filterView.backgroundColor = .appColor(.SecondViewBackGround)
            }else{
                filterView.backgroundColor = .appColor(.MainColor)?.withAlphaComponent(0.30)
            }
            
            storeArray.removeAll()
            CurrentPage = 1
            lastPage = 1
            getStores(categoty: categoryid, lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: CurrentPage, searchText: searchText, rate: filter?.rate)
//            getSubcategory(id: categoryid )
            
        }
    }

    var isFromChatBoot = false
    var selectedStore: ((_ store: Store) -> Void)?

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.hideTabbar()
        UIApplication.shared.statusBarStyle = .darkContent
        IQKeyboardManager.shared.disabledToolbarClasses = [StoresVC.self]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        hideKeyboardWhenTappedAround()
       
        if viewTitle == "Stores".localized
        {
            categoryView.isHidden = true
            getStores(categoty: categoryid, lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: 1, searchText: searchText, rate: filter?.rate)
            
        }else
        {
            getSubcategory(id: categoryid)
        }
    }
    func setupView() {
        collectionViewConfigration()
        viewTitleLbl.text = viewTitle
        searchTf.delegate = self
        storesTableView.delegate = self
        storesTableView.dataSource = self
        storesTableView.register(UINib(nibName: "SingleStoresCell", bundle: nil), forCellReuseIdentifier: "SingleStoresCell")
        storesTableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        storesTableView.addSubview(refreshControl)
        setupStatusBar(color: UIColor.appColor(.BackGroundColor)!)
        setupGest()
    }
    private func collectionViewConfigration() {
        categoryCollectionView.delegate     = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UINib(nibName: "HeaderSectionCell", bundle: nil), forCellWithReuseIdentifier: "HeaderSectionCell")
    }
    private func setupGest() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelAction(_:)))
        searchIcon.isUserInteractionEnabled = true
        searchIcon.addGestureRecognizer(tap)
    }

    @objc func cancelAction(_ sender: UITapGestureRecognizer) {
        searchNotEnabled()
        searchTf.text = ""
        searchText = ""

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchAction(_:)), object: nil)
        perform(#selector(searchAction), with: nil, afterDelay: 0.5)
    }

    @objc func refresh(_ sender: AnyObject) {
        storeArray.removeAll()
        CurrentPage = 1
        lastPage = 1
        if viewTitle == "Stores".localized
        {
            getStores(categoty: categoryid, lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: 1, searchText: searchText,rate: filter?.rate)
        }else
        {
            getSubcategory(id: categoryid)
        }
        refreshControl.endRefreshing()
    }

    func searchEnabled() {
        searchContainerView.layer.borderColor = UIColor.appColor(.StoreStateClose)!.cgColor
        searchContainerView.layer.borderWidth = 1
        searchIcon.image = UIImage(systemName: "xmark")
        searchIcon.tintColor = UIColor.appColor(.StoreStateClose)!
    }

    func searchNotEnabled() {
        searchContainerView.borderColor = .clear
        searchContainerView.layer.borderWidth = 0
        searchIcon.image = UIImage(named: "search-icon")
    }

    func navigateToFilter() {
        let vc = AppStoryboards.Order.instantiate(FilterPopupVC.self)
        vc.delegate = self
        vc.filter = filter
        present(vc, animated: true)
    }

    func navigateToStore(storeID: Int) {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StoreDetailsVC") as! StoreDetailsVC
        vc.storeID = storeID
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: -  Action

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func filterAction(_ sender: Any) {
        navigateToFilter()
    }
}

// MARK: - delegate

extension StoresVC: UITextFieldDelegate {
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

        storeArray.removeAll()
        CurrentPage = 1
        lastPage = 1
        getStores(categoty: categoryid, lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: CurrentPage, searchText: searchText, rate: filter?.rate)
    }
}

extension StoresVC: FilterProtocal {
    func filter(filterData: FilterStores) {
        filter = filterData
    }
}

// MARK: - TableView Extension

extension StoresVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleStoresCell", for: indexPath) as! SingleStoresCell
        if indexPath.row < storeArray.count {
            cell.configeCell(store: storeArray[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromChatBoot == true {
            isFromChatBoot = false
            selectedStore?(storeArray[indexPath.row])
            navigationController?.popViewController(animated: true)
        } else {
            navigateToStore(storeID: storeArray[indexPath.row].id ?? 0)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let ContentHeight = scrollView.contentSize.height

        if isActive {
            if position > ContentHeight - storesTableView.frame.height {
                print("Done")
                isActive = false
                print(CurrentPage, lastPage)
                if CurrentPage < lastPage {
                    CurrentPage = CurrentPage + 1
                    getStores(categoty: categoryid, lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: CurrentPage, searchText: searchText, rate: filter?.rate)
                }
            }
        }
    }
}

// MARK: - API Extension -

extension StoresVC {
    func getStores(categoty: String, lat: String, long: String, page: Int, searchText: String , rate: String?) {
        showLoader()
        CreateOrderNetworkRouter.nearstores(categoty: categoty, lat: lat, long: long, page: "\(page)", searchText: searchText, rate: rate ?? "").send(GeneralModel<StoreModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            self.refreshControl.endRefreshing()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getStores(categoty: categoty, lat: lat, long: long, page: page, searchText: searchText ,rate:rate)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.stores.isEmpty == true {
                        self.storesTableView.isHidden = true
                        self.emptyImage.isHidden = false
                        self.emptyStack.isHidden = false
                    } else {
                        self.emptyImage.isHidden = true
                        self.emptyStack.isHidden = true
                        self.storesTableView.isHidden = false
                        self.storeArray.append(contentsOf: data.data?.stores ?? [])
                    }
                    self.lastPage = data.data?.pagination?.totalPages ?? 0
                    if self.isActive == false {
                        self.storesTableView.reloadData()
                    } else {
                        self.storesTableView.reloadWithAnimation()
                    }
                    self.isActive = true
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}
extension StoresVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell

        cell.cellTitile.text =  items[indexPath.row].name ?? ""
        
        if indexPath.row == selectedCategotyIndex {
            cell.cellBackGround.backgroundColor = UIColor.appColor(.MainColor)?.withAlphaComponent(0.70)
            cell.cellTitile.textColor = UIColor.appColor(.viewBackGround)
        } else {
            cell.cellBackGround.backgroundColor = UIColor.appColor(.viewBackGround)
            cell.cellTitile.textColor = UIColor.appColor(.MainFontColor)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCategotyIndex = indexPath.row
        storeArray.removeAll()
        CurrentPage = 1
        lastPage = 1
        self.getStoresFromSubCategories(lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: 1, subCategoryId: items[indexPath.row].id ?? 0)
        categoryCollectionView.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 48)
    }
}

extension StoresVC {
    func getSubcategory(id: String) {
        showLoader()
        
        HomeNetworkRouter.subCategory(id: id).send(GeneralModel<SubCategoryModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getSubcategory(id: id)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(response):
                if response.key == ResponceStatus.success.rawValue {
                    self.categoryCollectionView.isHidden = response.data?.subcategories.isEmpty ?? false
                    self.emptyImage.isHidden = !(response.data?.subcategories.isEmpty ?? false)
                    self.emptyStack.isHidden = !(response.data?.subcategories.isEmpty ?? false)
                    
                    self.items = response.data?.subcategories ?? []
                    if response.data?.subcategories.isEmpty != true
                    {
                            self.getStoresFromSubCategories(lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: 1, subCategoryId: response.data?.subcategories[0].id ?? 0)
                    }else
                    {
                        self.categoryView.isHidden = true
                        self.getStoresFromOneCategory(lat : defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "", page: 1, categoryName: self.categoryNameForApi )
//                        self.emptyImage.isHidden = false
//                        self.emptyStack.isHidden = false
//                        self.storesTableView.isHidden = true
                        self.selectedCategotyIndex = 0
                    }
                    
                }else {
                    self.showError(error: response.msg)
                }
                
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    func getStoresFromSubCategories(lat: String, long: String, page: Int,  subCategoryId : Int) {
        showLoader()
        CreateOrderNetworkRouter.nearStoresSubCategory(lat: lat , long: long, page: "\(page)", subCategoryId: subCategoryId).send(GeneralModel<StoreModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            self.refreshControl.endRefreshing()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getStoresFromSubCategories(lat: lat, long: long, page: page, subCategoryId: subCategoryId)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.stores.isEmpty == true {
                        
                        self.storesTableView.isHidden = true
                        self.emptyImage.isHidden = false
                        self.emptyStack.isHidden = false
                        self.selectedCategotyIndex = 0
                    } else {
                        self.emptyImage.isHidden = true
                        self.emptyStack.isHidden = true
                        self.storesTableView.isHidden = false
                        self.storeArray.append(contentsOf: data.data?.stores ?? [])
                    }
                    self.lastPage = data.data?.pagination?.totalPages ?? 0
                    if self.isActive == false {
                        self.storesTableView.reloadData()
                    } else {
                        self.storesTableView.reloadWithAnimation()
                    }
                    self.isActive = true
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
    
    func getStoresFromOneCategory(lat: String, long: String, page: Int,  categoryName : String) {
        showLoader()
        CreateOrderNetworkRouter.nearStoresOneCategory(lat: lat , long: long, page: "\(page)", categoryName: categoryName).send(GeneralModel<StoreModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            self.refreshControl.endRefreshing()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getStoresFromOneCategory(lat: lat, long: long, page: page, categoryName: categoryName)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.stores.isEmpty == true {
                        
                        self.storesTableView.isHidden = true
                        self.emptyImage.isHidden = false
                        self.emptyStack.isHidden = false
                        self.selectedCategotyIndex = 0
                    } else {
                        self.emptyImage.isHidden = true
                        self.emptyStack.isHidden = true
                        self.storesTableView.isHidden = false
                        self.storeArray.append(contentsOf: data.data?.stores ?? [])
                    }
                    self.lastPage = data.data?.pagination?.totalPages ?? 0
                    if self.isActive == false {
                        self.storesTableView.reloadData()
                    } else {
                        self.storesTableView.reloadWithAnimation()
                    }
                    self.isActive = true
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
    
}

// MARK: - DataClass

struct SubCategoryModel: Codable {
    let subcategories: [SubCategory]
}
