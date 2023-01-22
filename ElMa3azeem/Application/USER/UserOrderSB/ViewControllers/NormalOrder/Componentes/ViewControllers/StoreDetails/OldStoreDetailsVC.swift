////
////  StoreDetailsVC.swift
////  ElMa3azeem
////
////  Created by Abdullah Tarek & Ahmed Mostafa Halim on 1111/2022.
////
////
//
//import UIKit
//import SwiftMessages
//
//class OldStoreDetailsVC: BaseViewController {
//
//    @IBOutlet weak var topView: UIView!
//    @IBOutlet weak var countLbl: UILabel!
//    @IBOutlet weak var confirmView: UIView!
//    @IBOutlet weak var storeNameLbl: UILabel!
//    @IBOutlet weak var totalPriceLbl: UILabel!
//    @IBOutlet weak var MainTableView: UITableView!
//    @IBOutlet weak var itemsCountStack: UIStackView!
//    @IBOutlet weak var totalPriceStack: UIStackView!
//    @IBOutlet weak var selectItemFirstStack: UIStackView!
//    @IBOutlet weak var storeNoContructStack: UIStackView!
//    @IBOutlet weak var tableViewTopConstrain: NSLayoutConstraint!
//
//
//    let categoryCollectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
//    var selectedCategotyID = 0
//    var selectedCategotyIndex = 0
//    var selectedCategotyAttay = [Product]()
//    var indexpath = IndexPath()
//    var section = 0
//    var storeID = Int()
//    var totalPrice = Double()
//    var itemCount = 0
//    var StoreDate : StoreDetailsModel?
//    var SelectedProduct = [SelectedProductModel]()
//    var store : Store?
//
//    /*
//     this variable used to backup store data :
//     when select product and go to next view to complite order adn edit in quantity ,
//     this val reset data to recount the new produt
//     👇🏻*/
//    var storeDataBackup : StoreDetailsModel?
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //self.setupStatusBar
//        self.tabBarController?.hideTabbar()
//    }
//
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        getStoreDetailsData(id: "\(storeID)")
//        setupView()
//        MainTableView.alpha = 0
//    }
//
//    func setupView() {
//        itemsCountStack.isHidden = true
//        totalPriceStack.isHidden = true
//        storeNoContructStack.isHidden = true
//        selectItemFirstStack.isHidden = true
//        MainTableView.tableFooterView = UIView()
//        MainTableView.delegate = self
//        MainTableView.dataSource = self
//        MainTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 16, right: 0)
//        MainTableView.register(UINib(nibName: "NormalOrderTopCell", bundle: nil), forCellReuseIdentifier: "NormalOrderTopCell")
//        MainTableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
//        MainTableView.register(UINib(nibName: "StoreCategoryCell", bundle: nil), forCellReuseIdentifier: "StoreCategoryCell")
//        MainTableView.register(UINib(nibName: "noDataCell", bundle: nil), forCellReuseIdentifier: "noDataCell")
//
//        categoryCollectionView.showsVerticalScrollIndicator = false
//        categoryCollectionView.showsHorizontalScrollIndicator = false
//        categoryCollectionView.delegate = self
//        categoryCollectionView.dataSource = self
//        categoryCollectionView.backgroundColor = UIColor.white
//        categoryCollectionView.register(UINib(nibName: "HeaderSectionCell", bundle: nil), forCellWithReuseIdentifier: "HeaderSectionCell")
//
//        let confirmTaped = UITapGestureRecognizer(target: self, action: #selector(self.handleConfirmTaped(_:)))
//        confirmView.isUserInteractionEnabled = true
//        confirmView.addGestureRecognizer(confirmTaped)
//    }
//
//    func handleConfirmView() {
//        UIView.animate(withDuration: 0.3) { [weak self] in
//            guard let self = self else {return}
//            if self.totalPrice != 0 {
//                self.selectItemFirstStack.isHidden = true
//                self.itemsCountStack.isHidden = false
//                self.totalPriceStack.isHidden = false
//                self.totalPriceLbl.text = "\(self.totalPrice) \(defult.shared.getAppCurrency() ?? "")"
//            }
//        }
//    }
//
//    func addItem (menuID:Int, productID: Int ,productName: String,productIamge: String, productPrice: Int, groupID: Int, quantity: Int, totalPrice: Double, feature: [Feature], addition: [ProductAdditiveCategory]) {
//        self.SelectedProduct.append(SelectedProductModel(menuID: menuID, productID: productID, productName: productName, productIamge: productIamge, productPrice: productPrice, groupID: groupID, quantity: quantity, totalPrice: totalPrice, feature: feature, addition: addition))
//    }
//
//    func updateOrderDetails(products : [SelectedProductModel]) {
//
//        StoreDate = storeDataBackup
//        
//        SelectedProduct = products
//        itemCount = 0
//        totalPrice = 0
//        products.forEach { item in
//            self.totalPrice = self.totalPrice + item.totalPrice
//            self.itemCount = self.itemCount + item.quantity
//            StoreDate?.store.memu.enumerated().forEach { (menuIndex , menu) in
//                if item.menuID == menu.id {
//                    let index = self.StoreDate?.store.memu[menuIndex].products.firstIndex(where: {$0.id == item.productID}) ?? 0
//                    self.StoreDate?.store.memu[menuIndex].products[index].features = item.feature
//                    self.StoreDate?.store.memu[menuIndex].products[index].productAdditiveCategories = item.addition
//                    self.StoreDate?.store.memu[menuIndex].products[index].group?.id = item.groupID
//                    self.StoreDate?.store.memu[menuIndex].products[index].quantity = item.quantity
//                }
//            }
//        }
//
//        itemsCountStack.isHidden = true
//        totalPriceStack.isHidden = true
//        storeNoContructStack.isHidden = true
//        selectItemFirstStack.isHidden = true
//
//        if itemCount == 0{
//            handleConfirmView()
//        }else{
//            selectItemFirstStack.isHidden = false
//        }
//
//        totalPriceLbl.text = "\(self.totalPrice)"
//        countLbl.text = "\(self.itemCount)"
//
//        self.MainTableView.reloadWithAnimation()
//    }
//
//    //MARK: - Navigations
//    func showOfferPopup(url : String) {
//        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue , bundle: nil)
//        let vc  = storyboard.instantiateViewController(withIdentifier: "OfferPopupVC") as! OfferPopupVC
//        vc.imageUrl = url
//        vc.modalPresentationStyle = .fullScreen
//        self.addChild(vc)
//        vc.view.frame = self.view.frame
//        self.view.addSubview(vc.view)
//        vc.didMove(toParent: self)
//    }
//
//    func showStoreNotAvilable() {
//        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue , bundle: nil)
//        let vc  = storyboard.instantiateViewController(withIdentifier: "StoreNotAvilablePopupVC") as! StoreNotAvilablePopupVC
//        vc.backToHome = {
//            self.navigationController?.popViewController(animated: true)
//        }
//        present(vc, animated: true, completion: nil)
//    }
//
//    func showStoreNoContractPopup() {
//        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue , bundle: nil)
//        let vc  = storyboard.instantiateViewController(withIdentifier: "StoreNoContractVC") as! StoreNoContractVC
//        vc.backToHome = {
//            self.navigationController?.popViewController(animated: true)
//        }
//        present(vc, animated: true, completion: nil)
//    }
//
//    func navigateToRate() {
//        let storyboard = UIStoryboard(name: StoryBoard.More.rawValue , bundle: nil)
//        let vc  = storyboard.instantiateViewController(withIdentifier: "UserCommentVC") as! UserCommentVC
//        vc.storeID = StoreDate?.store.id ?? 0
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func navigateToWorkTime() {
//        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue , bundle: nil)
//        let vc  = storyboard.instantiateViewController(withIdentifier: "WorkTimePopupVC") as! WorkTimePopupVC
//        vc.timesArray = StoreDate?.store.openingHours ?? []
//        present(vc, animated: true, completion: nil)
//    }
//
//    func navigateToChooseBranch() {
//        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue , bundle: nil)
//        let vc  = storyboard.instantiateViewController(withIdentifier: "ChooseStoreVC") as! ChooseStoreVC
//        vc.storeID = StoreDate?.store.id ?? 0
//        vc.delegate = self
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func navigateToProductDeatils(menuID : Int , productID : Int) {
//        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue , bundle: nil)
//        let vc  = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
//        vc.productID = productID
//        vc.menuID = menuID
//        vc.delegate = self
//        present(vc, animated: true, completion: nil)
//    }
//
//    func navigateToCompleteOrder(SelectedProduct : [SelectedProductModel]) {
//        //MARK: - edit
//        if StoreDate?.store.available == false || StoreDate?.store.isOpen == false {
//            showStoreNotAvilable()
//        }else{
//            if StoreDate?.store.hasContract == false {
//                navigateNoContractStore()
//            }else{
//                completeHasContractOrder(SelectedProduct: SelectedProduct)
//            }
//        }
//    }
//
//    func completeHasContractOrder(SelectedProduct : [SelectedProductModel]) {
//        do {
//            let selectedProduct = try ValidationService.validate(selectProduct: SelectedProduct)
//            self.navigateHasContractStore(SelectedProduct: selectedProduct)
//        } catch {
//            showError(error: error.localizedDescription)
//        }
//    }
//
//    func navigateHasContractStore(SelectedProduct : [SelectedProductModel]) {
//        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue , bundle: nil)
//        let vc  = storyboard.instantiateViewController(withIdentifier: "CompleteOrderVC") as! CompleteOrderVC
//        vc.SelectedProduct = self.SelectedProduct
//        vc.store = store
//        vc.storeID = StoreDate?.store.id ?? 0
//        vc.backToStoreDetails = { [weak self] products in
//            guard let self = self else {return}
//            self.updateOrderDetails(products: products)
//        }
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    func navigateNoContractStore() {
//        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue , bundle: nil)
//        let vc  = storyboard.instantiateViewController(withIdentifier: "CompleteOrderNoContructVC") as! CompleteOrderNoContructVC
//        vc.viewTitle = StoreDate?.store.name ?? ""
//        vc.store = store
//        vc.storeID = StoreDate?.store.id ?? 0
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    //MARK: - Actions
//
//    @objc func handleConfirmTaped(_ sender: UITapGestureRecognizer) {
//        self.navigateToCompleteOrder(SelectedProduct: self.SelectedProduct)
//    }
//
//    func openMap(latitude:String, longitude: String, title: String) {
//        openMaps(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0, title: title)
//    }
//
//    @IBAction func backAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//}
//
////MARK: - Delegate Extension -
//extension OldStoreDetailsVC : selectBranchProtocol {
//    func selectBranch(id: Int) {
//
//        itemsCountStack.isHidden = true
//        totalPriceStack.isHidden = true
//        storeNoContructStack.isHidden = true
//        selectItemFirstStack.isHidden = true
//
//        self.selectedCategotyAttay.removeAll()
//        self.storeID = id
//        self.getStoreDetailsData(id: "\(storeID)")
//    }
//}
//
//extension OldStoreDetailsVC : selectProductProtocol {
//    func selectProduct(menuID : Int, productID: Int, productName: String, productIamge: String, productPrice: Int, groupID: Int, quantity: Int, totalPrice: Double, feature: [Feature], addition: [ProductAdditiveCategory]) {
//        self.addItem(menuID: menuID, productID: productID, productName: productName, productIamge: productIamge, productPrice: productPrice, groupID: groupID, quantity: quantity, totalPrice: totalPrice, feature: feature, addition: addition)
//
//        let index = self.StoreDate?.store.memu[self.selectedCategotyIndex].products.firstIndex(where: {$0.id == productID}) ?? 0
//        self.StoreDate?.store.memu[self.selectedCategotyIndex].products[index].features = feature
//        self.StoreDate?.store.memu[self.selectedCategotyIndex].products[index].productAdditiveCategories = addition
//        self.StoreDate?.store.memu[self.selectedCategotyIndex].products[index].group?.id = groupID
//        let count = self.StoreDate?.store.memu[self.selectedCategotyIndex].products[index].quantity ?? 0
//        self.StoreDate?.store.memu[self.selectedCategotyIndex].products[index].quantity = quantity + count
//        self.itemCount = itemCount + quantity
//        self.totalPrice = self.totalPrice + totalPrice
//        self.countLbl.text = "\(self.itemCount)"
//        handleConfirmView()
//        MainTableView.reloadRows(at: [indexpath], with: .automatic)
//    }
//}
//
//
////MARK: - TableView Extension -
//extension OldStoreDetailsVC : UITableViewDelegate , UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if StoreDate?.store.hasContract == false {
//            return 2
//        }else{
//            return 10
//        }
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if section == 0 {
//            return 1
//        }else if section == 1 {
//            return 1
//        }else{
//            return 10
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let infoCell = tableView.dequeueReusableCell(withIdentifier: "NormalOrderTopCell") as! NormalOrderTopCell
//        let searchCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
//        let categotyItemCell = tableView.dequeueReusableCell(withIdentifier: "StoreCategoryCell") as! StoreCategoryCell
//        let noData = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as! noDataCell
//
//        if indexPath.section == 0 {
//
//            infoCell.configCell(model: StoreDate?.store)
//            infoCell.didPressBack = { [weak self] in
//                guard let self = self else {return}
//                self.navigationController?.popViewController(animated: true)
//            }
//
//            infoCell.didPressRate = { [weak self] in
//                guard let self = self else {return}
//                self.navigateToRate()
//            }
//
//            infoCell.didPressLocation = { [weak self] in
//                guard let self = self else {return}
//                self.openMap(latitude: self.StoreDate?.store.lat ?? "", longitude: self.StoreDate?.store.long ?? "", title: self.StoreDate?.store.name ?? "")
//            }
//
//            infoCell.didPressWorkTime = { [weak self] in
//                guard let self = self else {return}
//                self.navigateToWorkTime()
//            }
//
//            infoCell.didPressChangeBranch = { [weak self] in
//                guard let self = self else {return}
//                self.navigateToChooseBranch()
//            }
//
//            return infoCell
//
//        }else if indexPath.section == 1 {
//
//            searchCell.searchText = { [weak self] text in
//                guard let self = self else {return}
//                print(text)
//            }
//            return searchCell
//
//        }else{
//
//            if (StoreDate?.store.memu.count ?? 0) > indexPath.row {
////                categotyItemCell.configCell(model: StoreDate?.store.memu[indexPath.section - 2].products[indexPath.row])
//
//                categotyItemCell.selectCategory = { [weak self] in
//                    guard let self = self else {return}
//                    self.navigateToProductDeatils(menuID: self.StoreDate?.store.memu[indexPath.section - 2].id ?? 0, productID: self.StoreDate?.store.memu[indexPath.section - 2].products[indexPath.row].id ?? 0)
//                    self.indexpath = indexPath
//                }
//            }else{
//
//            }
//
//            return categotyItemCell
//
//        }
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        if section == 1 {
//            return 50
//        }else{
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        guard tableView.numberOfSections > 1 else {
//                return nil
//            }
//
////        if section == 1 {
//            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
//            headerView.backgroundColor = .purple
//            headerView.addSubview(categoryCollectionView)
//            return categoryCollectionView
////        }else{
////            return nil
////        }
//    }
//
//    func setupTableViewHeader(tableView : UITableView,section:Int) -> UIView {
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 20))
//        let label : UILabel = {
//                let imageView = UILabel()
//                return imageView
//            }()
//        label.text = StoreDate?.store.memu[section - 2].name
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//        headerView.addSubview(label)
//        label.anchor(top: headerView.topAnchor, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 5, paddingRight: 20, width: 0, height: 20)
//
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if indexPath.section == 0 {
//            return UITableView.automaticDimension
//        }else if indexPath.section == 1{
//            return 60
//        }else{
//            return UITableView.automaticDimension
//        }
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let position = MainTableView.contentOffset.y
//
//        if position > 360 {
//            UIView.animate(withDuration: 0.4, delay: 0, options: [.allowAnimatedContent]) {
//                self.topView.isHidden = false
//                self.topView.alpha = 1
//            } completion: { isFinish in
//                self.tableViewTopConstrain.constant = 60
//            }
//        }else{
//            UIView.animate(withDuration: 0.4, delay: 0, options: [.allowAnimatedContent]) {
//                self.topView.isHidden = true
//                self.topView.alpha = 0
//            } completion: { isFinish in
//                self.tableViewTopConstrain.constant = 0
//            }
//        }
//    }
//
//    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
//        return indexPath
//    }
//}
//
////MARK: - CollectionView Extension -
//extension OldStoreDetailsVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return StoreDate?.store.memu.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
//
//        cell.configCell(title: StoreDate?.store.memu[indexPath.row].name ?? "")
//        cell.cellBackGround.backgroundColor = UIColor.appColor(.MainColor)
//
//        if indexPath.row == selectedCategotyIndex {
//            cell.cellBackGround.backgroundColor = UIColor.appColor(.MainColor)?.withAlphaComponent(0.10)
//            cell.cellTitile.textColor = UIColor.appColor(.MainColor)
//        }else{
//            cell.cellBackGround.backgroundColor = .white
//            cell.cellTitile.textColor = UIColor(hexString: "989898")
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (StoreDate?.store.memu[indexPath.row].name.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]).width)! + 20, height: 48)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.selectedCategotyAttay.removeAll()
//        self.selectedCategotyAttay = StoreDate?.store.memu[indexPath.row].products ?? []
//        self.selectedCategotyID = StoreDate?.store.memu[indexPath.row].id ?? 0
//        self.selectedCategotyIndex = indexPath.row
//        self.MainTableView.reloadData()
//        self.categoryCollectionView.reloadData()
//        collectionView.deselectItem(at: indexPath, animated: true)
//    }
//
//}
//
////MARK: - API Extension -
//extension OldStoreDetailsVC {
//    func getStoreDetailsData(id: String) {
//        self.showLoader()
//        CreateOrderNetworkRouter.storeDetails(id: "\(self.storeID)", lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "").send(GeneralModel<StoreDetailsModel>.self) { [weak self] result in
//            guard let self = self else {return}
//            self.hideLoader()
//            switch result {
//            case .failure(let error):
//                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
//                    self.showNoInternetConnection { [weak self] in
//                        self?.getStoreDetailsData(id: id)
//                    }
//                } else {
//                    self.showError(error: error.localizedDescription)
//                }
//            case .success(let data):
//                if data.key == ResponceStatus.success.rawValue {
//
//                    self.StoreDate = data.data
//                    self.storeDataBackup = data.data
//
//                    self.store = Store(id: self.StoreDate?.store.id, rate: self.StoreDate?.store.rate, distance: self.StoreDate?.store.distance, name: self.StoreDate?.store.name, categoryName: self.StoreDate?.store.categoryName, long: self.StoreDate?.store.long, icon: self.StoreDate?.store.icon, address: self.StoreDate?.store.address, lat: self.StoreDate?.store.lat, isOpen: self.StoreDate?.store.isOpen, available: self.StoreDate?.store.available)
//
//                    self.MainTableView.alpha = 1
//
//                    if data.data?.store.hasContract == false {
//                        self.showStoreNoContractPopup()
//                        self.storeNoContructStack.isHidden = false
//                    }else{
//                        self.selectItemFirstStack.isHidden = false
//                    }
//
//                    if data.data?.store.available == false || data.data?.store.isOpen == false{
//                        self.showStoreNotAvilable()
//                    }
//
//                    if data.data?.store.offer == true {
//                        self.showOfferPopup(url : data.data?.store.offerImage ?? "")
//                    }
//
//                    self.storeNameLbl.text = data.data?.store.name
//
//                    if data.data?.store.memu.isEmpty == false {
//                        self.selectedCategotyID = data.data?.store.memu[0].products[0].id ?? 0
//                        self.selectedCategotyAttay = data.data?.store.memu.first(where: {$0.id == self.selectedCategotyID})?.products ?? []
//                    }
//
//                    self.categoryCollectionView.reloadData()
//                    self.MainTableView.reloadWithAnimation()
//
//                }else{
//                    self.showError(error: data.msg)
//                }
//
//            }
//        }
//    }
//}
