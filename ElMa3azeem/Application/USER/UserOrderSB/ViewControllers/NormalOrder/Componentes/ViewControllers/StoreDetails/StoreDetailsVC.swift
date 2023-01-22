//
//  NewStoreDetailsVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 24/01/2022.
//

import Lottie
import UIKit

class StoreDetailsVC: BaseViewController {
    // MARK: - MainView

    @IBOutlet weak var locationStackView        : UIStackView!
    @IBOutlet weak var MainStackView            : UIStackView!
    @IBOutlet weak var mainScrollViewTopConst   : NSLayoutConstraint!
    @IBOutlet weak var topViewTitleLbl          : UILabel!
    @IBOutlet weak var storeInfoView            : UIView!
    @IBOutlet weak var categotyView             : UIView!
    @IBOutlet weak var searchView               : UIView!
    @IBOutlet weak var searchTf                 : UITextField!
    @IBOutlet weak var mainTitle                : UILabel!

    // MARK: - TopViewLayout

    @IBOutlet weak var deliveryMainLabel        : UILabel!
    @IBOutlet weak var imageCoverView           : UIView!
    @IBOutlet weak var storeCoverImage          : UIImageView!
    @IBOutlet weak var mainStoreNameLbl         : UILabel!
    @IBOutlet weak var storeDetailsNameLbl      : UILabel!
    @IBOutlet weak var storeIsOpenStateLbl      : UILabel!
    @IBOutlet weak var storeIconeImage          : UIImageView!
    @IBOutlet weak var storeRateLbl             : UILabel!
    @IBOutlet weak var storeDistancelbl         : UILabel!
//    @IBOutlet weak var storeDeliveryPricelbl    : UILabel!
    @IBOutlet weak var stateview                : UIView!
    @IBOutlet weak var storeAddressLbl          : UILabel!

    @IBOutlet weak var firstWorkTimeView        : UIView!
    @IBOutlet weak var secondWorkTimeView       : UIView!

    @IBOutlet weak var noDataView               : LottieAnimationView!

    // MARK: - CategoryLayout

    @IBOutlet weak var categoryCollectionView   : UICollectionView!

    // MARK: - ProductsLayout

    @IBOutlet weak var ProductsTableView        : UITableView!

    // MARK: - Old

    @IBOutlet weak var countLbl                 : UILabel!
    @IBOutlet weak var confirmView              : UIView!
    @IBOutlet weak var totalPriceLbl            : UILabel!
    @IBOutlet weak var itemsCountStack          : UIStackView!
    @IBOutlet weak var totalPriceStack          : UIStackView!
    @IBOutlet weak var selectItemFirstStack     : UIStackView!
    @IBOutlet weak var storeNoContructStack     : UIStackView!

    // MARK: - Variables

    var selectedCategotyID      = 0
    var selectedCategotyIndex   = 0
    var selectedCategotyAttay   = [Product]()
    var indexpath               = IndexPath()
    var section                 = 0
    var storeID                 = Int()
    var totalPrice              = Double()
    var itemCount               = 0
    var StoreDate               : StoreDetailsModel?
    var SelectedProduct         = [SelectedProductModel]()
    var filterdProduct          = [Memu]()
    var store                   : Store?
    var product                 : Product?
    var searchText              = ""
    var isFilterd               = false
    var comeFromFavorite        = false
    var indexPath               = IndexPath(item: 0, section: 0)
    var currentTableIndex       : Int = 0 {

        didSet {
            guard oldValue != currentTableIndex else {return}
            selectedCategotyIndex = currentTableIndex
            indexPath = IndexPath(item: currentTableIndex, section: 0)
            categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            categoryCollectionView.reloadData()
            
        }
        
    }

    /*
     this variable used to backup store data :
     when select product and go to next view to complite order and edit in quantity ,
     this val reset data to recount the new produt
     👇🏻*/
    var storeDataBackup: StoreDetailsModel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // setupStatusBar
        tabBarController?.hideTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
        getStoreDetailsData(id: "\(storeID)")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        removeStatusBarColor()
    }
    deinit {
        UIApplication.shared.statusBarStyle = .darkContent
    }

    // MARK: - SetupViews

    func setupMainView() {
        removeStatusBarColor()
        noDataView           .isHidden = true
        itemsCountStack      .isHidden = true
        totalPriceStack      .isHidden = true
        storeNoContructStack .isHidden = true
        selectItemFirstStack .isHidden = true

        searchTf.delegate = self

        setupTopViewStyle()
        setupCollectionView()
        setupTableView()

        confirmView.backgroundColor = .white

        let confirmTaped = UITapGestureRecognizer(target: self, action: #selector(handleConfirmTaped(_:)))
        confirmView.isUserInteractionEnabled = true
        confirmView.addGestureRecognizer(confirmTaped)

        let openAddrees = UITapGestureRecognizer(target: self, action: #selector(openMapAction))
        locationStackView.addGestureRecognizer(openAddrees)
    }

    @objc func openMapAction() {
        openMap(latitude: StoreDate?.store.lat ?? "", longitude: StoreDate?.store.long ?? "", title: StoreDate?.store.name ?? "")
    }

    func setupTableView() {
        ProductsTableView.tableFooterView = UIView()
        ProductsTableView.delegate = self
        ProductsTableView.dataSource = self
        ProductsTableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 16, right: 0)
        ProductsTableView.register(UINib(nibName: "StoreCategoryCell", bundle: nil), forCellReuseIdentifier: "StoreCategoryCell")
        ProductsTableView.register(UINib(nibName: "noDataCell", bundle: nil), forCellReuseIdentifier: "noDataCell")
    }

    func setupTopViewStyle() {
        imageCoverView.layer.cornerRadius   = 12
        imageCoverView.layer.maskedCorners  = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        storeCoverImage.layer.cornerRadius  = 12
        storeCoverImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]

        setupAnimationView()
    }

    func setupTopViewData(model: StoreDetailsData?) {
        storeCoverImage.setImage(image: model?.cover ?? "", loading: true)
        topViewTitleLbl         .text = model?.name
        mainTitle               .text = model?.name
        mainStoreNameLbl        .text = model?.name
        storeDetailsNameLbl     .text = model?.name
        storeState(state: model?.isOpen ?? false)
//        storeDeliveryPricelbl   .text = model?.deliveryPrice
        storeAddressLbl         .text = model?.address
        storeIconeImage.setImage(image: model?.icon ?? "", loading: true)
        storeRateLbl            .text = model?.rate
        storeDistancelbl        .text = model?.distance
//        if model?.hasDelivery == false
//        {
//            deliveryMainLabel.text      = "Sorry We don't have delivery service right now".localized
//            storeDeliveryPricelbl.text  = ""
//        }else
//        {
//            deliveryMainLabel.text      = "Delivery price through us :".localized
//            storeDeliveryPricelbl.text  = model?.deliveryPrice
//        }
    }

    func storeState(state: Bool) {
        if state == true {
            stateview.backgroundColor   = UIColor.appColor(.StoreStateOpen)
            storeIsOpenStateLbl.text    = "Open".localized
        } else {
            stateview.backgroundColor   = UIColor.appColor(.StoreStateClose)
            storeIsOpenStateLbl.text    = "Closed".localized
        }
    }

    func setupCollectionView() {
        categotyView.semanticContentAttribute = Language.isArabic() ? .forceRightToLeft : .forceLeftToRight
        categoryCollectionView.delegate     = self
        categoryCollectionView.dataSource   = self

        categoryCollectionView.register(UINib(nibName: "HeaderSectionCell", bundle: nil), forCellWithReuseIdentifier: "HeaderSectionCell")
    }

    func handleConfirmView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            if self.totalPrice != 0 {
                self.selectItemFirstStack   .isHidden = true
                self.itemsCountStack        .isHidden = false
                self.totalPriceStack        .isHidden = false
                self.confirmView            .backgroundColor = .appColor(.MainColor)
                self.totalPriceLbl.text = "\(self.totalPrice) \(defult.shared.getAppCurrency() ?? "")"
            }
        }
    }

    func addItem(menuID: Int, productID: Int, productName: String, productIamge: String, productPrice: Double, groupID: Int, quantity: Int, totalPrice: Double, feature: [Feature], addition: [ProductAdditiveCategory]) {
        let item = SelectedProductModel(menuID: menuID, productID: productID, productName: productName, productIamge: productIamge, productPrice: productPrice, groupID: groupID, quantity: quantity, totalPrice: totalPrice, feature: feature, addition: addition)

        guard let previousItemIndex = SelectedProduct.firstIndex(where: { $0.productID == productID }) else {
            SelectedProduct.append(item)
            return
        }

        guard item == SelectedProduct[previousItemIndex] else {
            SelectedProduct.append(item)
            return
        }

        SelectedProduct[previousItemIndex].quantity += quantity
    }

    @objc func handleConfirmTaped(_ sender: UITapGestureRecognizer) {
        navigateToCompleteOrder(SelectedProduct: SelectedProduct)
    }

    func updateOrderDetails(products: [SelectedProductModel]) {
        StoreDate = storeDataBackup

        SelectedProduct = products
        itemCount = 0
        totalPrice = 0
        products.forEach { item in
            self.totalPrice = self.totalPrice + item.totalPrice
            self.itemCount = self.itemCount + item.quantity
            StoreDate?.store.memu?.enumerated().forEach { menuIndex, menu in
                if item.menuID == menu.id {
                    let index = self.StoreDate?.store.memu?[menuIndex].products.firstIndex(where: { $0.id == item.productID }) ?? 0
                    self.StoreDate?.store.memu?[menuIndex].products[index].features = item.feature
                    self.StoreDate?.store.memu?[menuIndex].products[index].productAdditiveCategories = item.addition
                    self.StoreDate?.store.memu?[menuIndex].products[index].group?.id = item.groupID
                    let count = self.StoreDate?.store.memu?[menuIndex].products[index].quantity ?? 0
                    self.StoreDate?.store.memu?[menuIndex].products[index].quantity = item.quantity + count
                }
            }
        }

        itemsCountStack.isHidden = true
        totalPriceStack.isHidden = true
        storeNoContructStack.isHidden = true
        selectItemFirstStack.isHidden = true

        if itemCount != 0 {
            handleConfirmView()
            confirmView.backgroundColor = .appColor(.MainColor)
        } else {
            selectItemFirstStack.isHidden = false
            confirmView.backgroundColor = .white
        }

        totalPriceLbl.text = "\(totalPrice)"
        countLbl.text = "\(itemCount)"

        ProductsTableView.reloadWithAnimation()
    }

    func setupAnimationView() {
        noDataView.contentMode = .scaleAspectFit
        noDataView.loopMode = .playOnce
        noDataView.animationSpeed = 1
    }

    // MARK: - Navigations

    func navigateToRate() {
        let storyboard = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserCommentVC") as! UserCommentVC
        vc.storeID = StoreDate?.store.id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateToWorkTime() {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WorkTimePopupVC") as! WorkTimePopupVC
        vc.timesArray = StoreDate?.store.openingHours ?? []
        present(vc, animated: true, completion: nil)
    }

    func navigateToChooseBranch() {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChooseStoreVC") as! ChooseStoreVC
        vc.storeID = StoreDate?.store.id ?? 0
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    func openMap(latitude: String, longitude: String, title: String) {
        openMaps(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0, title: title)
    }

    func showOfferPopup(url: String) {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OfferPopupVC") as! OfferPopupVC
        vc.imageUrl = url
        vc.modalPresentationStyle = .fullScreen
        addChild(vc)
        vc.view.frame = view.frame
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    func showStoreNotAvilable() {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StoreNotAvilablePopupVC") as! StoreNotAvilablePopupVC
        vc.backToHome = {
            self.navigationController?.popViewController(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }

    func showStoreNoContractPopup() {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StoreNoContractVC") as! StoreNoContractVC
        vc.backToHome = {
            self.navigationController?.popViewController(animated: true)
        }
        present(vc, animated: true, completion: nil)
    }

    func navigateToProductDeatils(menuID: Int, productID: Int) {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
        vc.productID = productID
        vc.menuID = menuID
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    func navigateToCompleteOrder(SelectedProduct: [SelectedProductModel]) {
        // MARK: - edit

        if StoreDate?.store.available == false || StoreDate?.store.isOpen == false {
            showStoreNotAvilable()
        } else {
            if StoreDate?.store.hasContract == false {
                navigateNoContractStore()
            } else {
                completeHasContractOrder(SelectedProduct: SelectedProduct)
            }
        }
    }

    func completeHasContractOrder(SelectedProduct: [SelectedProductModel]) {
        do {
            let selectedProduct = try ValidationService.validate(selectProduct: SelectedProduct)
            navigateHasContractStore(SelectedProduct: selectedProduct)
        } catch {
            showError(error: error.localizedDescription)
        }
    }

    func navigateHasContractStore(SelectedProduct: [SelectedProductModel]) {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CompleteOrderVC") as! CompleteOrderVC
        vc.SelectedProduct = self.SelectedProduct
        vc.store = store
        vc.haveDelivery = StoreDate?.store.hasDelivery ?? true
        vc.storeID = StoreDate?.store.id ?? 0
        vc.backToStoreDetails = { [weak self] products in
            guard let self = self else { return }
            self.updateOrderDetails(products: products)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    func navigateNoContractStore() {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CompleteOrderNoContructVC") as! CompleteOrderNoContructVC
        vc.viewTitle = StoreDate?.store.name ?? ""
        vc.store = store
        vc.storeID = StoreDate?.store.id ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Actions

    @IBAction func dismissAction(_ sender: Any) {
        ProductsTableView.setContentOffset(.zero, animated: true)
        mainScrollViewTopConst.constant = 0
        removeStatusBarColor()
        storeInfoView.isHidden = false
        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                        }
                }
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func rateAction(_ sender: Any) {
        navigateToRate()
    }

    @IBAction func locationAction(_ sender: Any) {
        openMap(latitude: StoreDate?.store.lat ?? "", longitude: StoreDate?.store.long ?? "", title: StoreDate?.store.name ?? "")
    }

    @IBAction func workTimeAction(_ sender: Any) {
        navigateToWorkTime()
    }

    @IBAction func changeStoreBranchAction(_ sender: Any) {
        navigateToChooseBranch()
    }
    
    @IBAction func shareButton(_ sender: Any) {
        // Setting description
           let firstActivityItem = "Description you want.."

           // Setting url
           let secondActivityItem : NSURL = NSURL(string: "http://your-url.com/")!
           
           // If you want to use an image
           let image : UIImage = UIImage(named: "share")!
           let activityViewController : UIActivityViewController = UIActivityViewController(
               activityItems: [firstActivityItem, secondActivityItem, image], applicationActivities: nil)
           
           // This lines is for the popover you need to show in iPad
           activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
           
           // This line remove the arrow of the popover to show in iPad
           activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
           activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
           
           // Pre-configuring activity items
           activityViewController.activityItemsConfiguration = [
           UIActivity.ActivityType.message
           ] as? UIActivityItemsConfigurationReading
           
           // Anything you want to exclude
           activityViewController.excludedActivityTypes = [
               UIActivity.ActivityType.postToWeibo,
               UIActivity.ActivityType.print,
               UIActivity.ActivityType.mail,
               UIActivity.ActivityType.assignToContact,
               UIActivity.ActivityType.saveToCameraRoll,
               UIActivity.ActivityType.addToReadingList,
               UIActivity.ActivityType.postToFlickr,
               UIActivity.ActivityType.postToVimeo,
               UIActivity.ActivityType.postToTencentWeibo,
               UIActivity.ActivityType.postToFacebook
           ]
           
           activityViewController.isModalInPresentation = true
           self.present(activityViewController, animated: true, completion: nil)
        
    }
}

// MARK: - TableView Extension -

extension StoreDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFilterd {
            return filterdProduct.count
        } else {
            return StoreDate?.store.memu?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilterd {
            return filterdProduct[section].products.count
        } else {
            return StoreDate?.store.memu?[section].products.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let categotyItemCell = tableView.dequeueReusableCell(withIdentifier: "StoreCategoryCell") as! StoreCategoryCell

        if indexPath.row < StoreDate?.store.memu?[indexPath.section].products.count ?? 0 {
            if isFilterd {
                categotyItemCell.configCell(model: filterdProduct[indexPath.section].products[indexPath.row])
                categotyItemCell.selectCategory = { [weak self] in
                    guard let self = self else { return }
                    self.navigateToProductDeatils(menuID: self.filterdProduct[indexPath.section].id, productID: self.filterdProduct[indexPath.section].products[indexPath.row].id ?? 0)
                    self.indexpath = indexPath
                }
                return categotyItemCell
            } else {
                currentTableIndex = tableView.indexPathsForVisibleRows?.first?.section ?? 0
                categotyItemCell.configCell(model: StoreDate?.store.memu?[indexPath.section].products[indexPath.row])
                categotyItemCell.selectCategory = { [weak self] in
                    guard let self = self else { return }
                    self.navigateToProductDeatils(menuID: self.StoreDate?.store.memu?[indexPath.section].id ?? 0, productID: self.StoreDate?.store.memu?[indexPath.section].products[indexPath.row].id ?? 0)
                    self.indexpath = indexPath
                }
                return categotyItemCell
            }
        } else {
            let noData = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as! noDataCell
            return noData
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if StoreDate?.store.memu?[section].products.isEmpty == true {
//            return nil
//        }
//        return setupTableViewHeader(tableView: tableView, section: section)
//    }

//    func setupTableViewHeader(tableView: UITableView, section: Int) -> UIView {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
//        headerView.backgroundColor = .appColor(.BackGroundColor)
//        let label: UILabel = {
//            let imageView = UILabel()
//            return imageView
//        }()
//        label.text = StoreDate?.store.memu?[section].name
//        label.backgroundColor = .appColor(.BackGroundColor)
//        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//        headerView.addSubview(label)
//        label.anchor(top: headerView.topAnchor, left: headerView.leftAnchor, bottom: headerView.bottomAnchor, right: headerView.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 20)
//
//        return headerView
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ProductsTableView.setContentOffset(.zero, animated: true)
//        categoryCollectionView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        currentTableIndex = indexPath.section
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == ProductsTableView {
            let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
            if scrollView.contentOffset.y < 0 {
                // swipes from bottom to top  of screen -> go up
                mainScrollViewTopConst.constant = 0
                removeStatusBarColor()
                storeInfoView.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
                print("\(scrollView.contentOffset.y) swipes from bottom to top  of screen -> go up")
            } else {
                // swipes from top to bottom of screen -> go down
                mainScrollViewTopConst.constant = 116
                setupStatusBar(color: UIColor.appColor(.MainColor)!)
                mainStoreNameLbl.textColor     = UIColor.appColor(.viewBackGround)
                storeInfoView.isHidden = true
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
                print("\(scrollView.contentOffset.y) swipes from top to bottom of screen -> go down")
            }
        }
    }
}

// MARK: - CollectionView Extension -

extension StoreDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StoreDate?.store.memu?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell

        cell.configCell(title: StoreDate?.store.memu?[indexPath.row].name ?? "")
        cell.cellBackGround.backgroundColor = UIColor.appColor(.MainColor)

        if indexPath.row == selectedCategotyIndex {
            cell.cellBackGround.backgroundColor = UIColor.appColor(.MainColor)?.withAlphaComponent(0.10)
            cell.cellTitile.textColor = UIColor.appColor(.MainColor)
        } else {
            cell.cellBackGround.backgroundColor = UIColor.appColor(.viewBackGround)
            cell.cellTitile.textColor = UIColor(hexString: "BCBCBC")
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (StoreDate?.store.memu?[indexPath.row].name.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]).width)! + 40, height: 48)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if StoreDate?.store.memu?[indexPath.row].products.isEmpty == false {
            selectedCategotyIndex = indexPath.row
            selectedCategotyID = StoreDate?.store.memu?[indexPath.row].id ?? 0
            let sectionRect = ProductsTableView.rect(forSection: indexPath.row)
            ProductsTableView.scrollRectToVisible(sectionRect, animated: true)
//            collectionView.deselectItem(at: indexPath, animated: true)
            categoryCollectionView.reloadData()
        } else {
            showError(error: "No products available in this category".localized)
        }
    }
}

// MARK: - Delegate Extension -

extension StoreDetailsVC: selectProductProtocol {
    func selectProduct(menuID: Int, productID: Int, productName: String, productIamge: String, productPrice: Double, groupID: Int, quantity: Int, totalPrice: Double, feature: [Feature], addition: [ProductAdditiveCategory]) {
        addItem(menuID: menuID, productID: productID, productName: productName, productIamge: productIamge, productPrice: productPrice, groupID: groupID, quantity: quantity, totalPrice: totalPrice, feature: feature, addition: addition)
        StoreDate?.store.memu?[indexpath.section].products[indexpath.row].features = feature
        StoreDate?.store.memu?[indexpath.section].products[indexpath.row].productAdditiveCategories = addition
        StoreDate?.store.memu?[indexpath.section].products[indexpath.row].group?.id = groupID
        let count = StoreDate?.store.memu?[indexpath.section].products[indexpath.row].quantity ?? 0
        StoreDate?.store.memu?[indexpath.section].products[indexpath.row].quantity = quantity + count
        itemCount = itemCount + quantity
        self.totalPrice = self.totalPrice + totalPrice
        countLbl.text = "\(itemCount)"
        handleConfirmView()
        ProductsTableView.reloadRows(at: [indexpath], with: .automatic)
    }
}

extension StoreDetailsVC: selectBranchProtocol {
    func selectBranch(id: Int) {
        itemsCountStack.isHidden = true
        totalPriceStack.isHidden = true
        storeNoContructStack.isHidden = true
        selectItemFirstStack.isHidden = true

        selectedCategotyAttay.removeAll()
        storeID = id
        getStoreDetailsData(id: "\(storeID)")
    }
}

// MARK: - delegate

extension StoreDetailsVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            isFilterd = false
            searchText = ""
            ProductsTableView.reloadWithAnimation()
        } else {
            isFilterd = true
            searchText = textField.text ?? ""
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchAction(_:)), object: nil)
            perform(#selector(searchAction), with: nil, afterDelay: 0.5)
        }
    }

    @objc func searchAction(_ textField: UITextField) {
        filterdProduct.removeAll()

        StoreDate?.store.memu?.enumerated().forEach({ _, menu in
            var item: Memu?
            item = menu
            item?.products = menu.products.filter({ $0.name?.contains(searchText) ?? false })
            self.filterdProduct.append(item!)
        })

        ProductsTableView.reloadWithAnimation()
        print(filterdProduct)
    }
}

// MARK: - API Extension

extension StoreDetailsVC {
    func getStoreDetailsData(id: String) {
        showLoader()
        CreateOrderNetworkRouter.storeDetails(id: "\(storeID)", lat: defult.shared.getData(forKey: .userLat) ?? "", long: defult.shared.getData(forKey: .userLong) ?? "").send(GeneralModel<StoreDetailsModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getStoreDetailsData(id: id)
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    print(data)

                    self.StoreDate = data.data
                    self.storeDataBackup = data.data
                    self.setupTopViewData(model: data.data?.store)

                    self.store = Store(id: self.StoreDate?.store.id, rate: self.StoreDate?.store.rate, distance: self.StoreDate?.store.distance, name: self.StoreDate?.store.name, categoryName: self.StoreDate?.store.categoryName, long: self.StoreDate?.store.long, icon: self.StoreDate?.store.icon, address: self.StoreDate?.store.address, lat: self.StoreDate?.store.lat, isOpen: self.StoreDate?.store.isOpen, available: self.StoreDate?.store.available)

                    if data.data?.store.hasContract == false {
                        self.showStoreNoContractPopup()
                        self.searchView.isHidden = true
                        self.ProductsTableView.isScrollEnabled = false
                        self.storeNoContructStack.isHidden = false
                        self.categotyView.isHidden = true
                        self.searchView.isHidden = true
                    } else {
                        if data.data?.store.memu?.isEmpty == false {
                            self.noDataView.isHidden = true
                            self.categotyView.isHidden = false
                            if data.data?.store.memu?[0].products.isEmpty == false {
                                self.selectedCategotyID = data.data?.store.memu?[0].products[0].id ?? 0
                                self.selectedCategotyIndex = 0
                            }
                        } else {
                            self.categotyView.isHidden = true
                            self.noDataView.isHidden = false
                        }

                        self.selectItemFirstStack.isHidden = false
                        self.ProductsTableView.isScrollEnabled = true
                        self.searchView.isHidden = false
                    }

                    if data.data?.store.available == false || data.data?.store.isOpen == false {
                        self.showStoreNotAvilable()
                    }

                    if data.data?.store.offer == true {
                        self.showOfferPopup(url: data.data?.store.offerImage ?? "")
                    }

                    if self.comeFromFavorite {
                        self.StoreDate?.store.memu?.enumerated().forEach({ index, menu in
                            guard let sectionIndex = menu.products.firstIndex(where: { $0.id == self.product?.id }) else { return }
                            self.navigateToProductDeatils(menuID: data.data?.store.memu?[index].id ?? 0, productID: self.product?.id ?? 0)
                        })
                    }

                    self.categoryCollectionView.reloadData()
                    self.ProductsTableView.reloadData()
                    self.MainStackView.reloadData(animationDirection: .down)
                    self.noDataView.play()

                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
}
