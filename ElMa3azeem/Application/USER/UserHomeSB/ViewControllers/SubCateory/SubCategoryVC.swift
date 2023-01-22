//
//  SubCategoryVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit

class SubCategoryVC: BaseViewController {
    
    // MARK: - CategoryLayout
    @IBOutlet weak var categoryCollectionView   : UICollectionView!
    
    // MARK: - MainView
    
    @IBOutlet weak var categoryView     : UIView!
    @IBOutlet weak var viewTitleLbl     : UILabel!
    @IBOutlet weak var collectioView    : UICollectionView!
    @IBOutlet weak var emptyImage       : UIImageView!
    @IBOutlet weak var emptyStack       : UIStackView!

    
    var items: [SubCategory] = []

    var categoryid: Int = 0
    var viewTitle: String = ""
    let refreshControl = UIRefreshControl()


    override func viewDidLoad() {
        super.viewDidLoad()
        viewTitleLbl.text = viewTitle
        collectionViewConfigration()
//        getSubcategory(id: categoryid)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized)
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        collectioView.addSubview(refreshControl)
        setupCollectionView()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.hideTabbar()
    }

    
    @objc func refresh(_ sender: AnyObject) {
        items.removeAll()
//        getSubcategory(id: categoryid)
        refreshControl.endRefreshing()
    }
    
    private func collectionViewConfigration() {
        collectioView.delegate = self
        collectioView.dataSource = self
        collectioView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
    }
    func setupCollectionView() {
        categoryView.semanticContentAttribute = Language.isArabic() ? .forceRightToLeft : .forceLeftToRight
        categoryCollectionView.delegate     = self
        categoryCollectionView.dataSource   = self

        categoryCollectionView.register(UINib(nibName: "HeaderSectionCell", bundle: nil), forCellWithReuseIdentifier: "HeaderSectionCell")
    }

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension SubCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell

        cell.setTitle(name: items[indexPath.row].name ?? "")
        cell.setImage(url: items[indexPath.row].image ?? "")
        
        cell.selectCategory = { [weak self] in
            guard let self = self else {return}
            let vc = AppStoryboards.Order.instantiate(StoresVC.self)
            vc.categoryid = "\(self.items[indexPath.row].id ?? 0)"
            vc.viewTitle = self.items[indexPath.row].name ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8
        let collectionViewSize = (collectionView.frame.width - padding) / 2
        return CGSize(width: collectionViewSize, height: collectionViewSize)
    }
}

extension SubCategoryVC {
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
                    self.collectioView.isHidden = response.data?.subcategories.isEmpty ?? false
                    self.emptyImage.isHidden = !(response.data?.subcategories.isEmpty ?? false)
                    self.emptyStack.isHidden = !(response.data?.subcategories.isEmpty ?? false)
                    
                    self.items = response.data?.subcategories ?? []

                } else {
                    self.showError(error: response.msg)
                }
                
                self.collectioView.reloadData()
            }
        }
    }
}

// MARK: - DataClass

//struct SubCategoryModel: Codable {
//    let subcategories: [SubCategory]
//}
// MARK: - CollectionView Extension

//extension SubCategoryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return  0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderSectionCell", for: indexPath) as! HeaderSectionCell
//
//        cell.configCell(title: StoreDate?.store.memu?[indexPath.row].name ?? "")
//        cell.cellBackGround.backgroundColor = UIColor.appColor(.MainColor)
//
//        if indexPath.row == selectedCategotyIndex {
//            cell.cellBackGround.backgroundColor = UIColor.appColor(.MainColor)?.withAlphaComponent(0.10)
//            cell.cellTitile.textColor = UIColor.appColor(.MainColor)
//        } else {
//            cell.cellBackGround.backgroundColor = UIColor.appColor(.viewBackGround)
//            cell.cellTitile.textColor = UIColor(hexString: "BCBCBC")
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (StoreDate?.store.memu?[indexPath.row].name.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]).width)! + 20, height: 48)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if StoreDate?.store.memu?[indexPath.row].products.isEmpty == false {
//            selectedCategotyIndex = indexPath.row
//            selectedCategotyID = StoreDate?.store.memu?[indexPath.row].id ?? 0
//            let sectionRect = ProductsTableView.rect(forSection: indexPath.row)
//            ProductsTableView.scrollRectToVisible(sectionRect, animated: true)
////            collectionView.deselectItem(at: indexPath, animated: true)
//            categoryCollectionView.reloadData()
//        } else {
//            showError(error: "No products available in this category".localized)
//        }
//    }
//}
//
//// MARK: Network
//
//extension SubCategoryVC
//{
//    func getStoreDetailsData(id: String) {
//        showLoader()
//        CreateOrderNetworkRouter.getSubCategories(id: categoryid).send(GeneralModel<StoreDetailsModel>.self) { [weak self] result in
//            guard let self = self else { return }
//            self.hideLoader()
//            switch result {
//            case let .failure(error):
//                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
//                    self.showNoInternetConnection { [weak self] in
//                        self?.getStoreDetailsData(id: id)
//                    }
//                } else {
//                    self.showError(error: error.localizedDescription)
//                }
//            case let .success(data):
//                if data.key == ResponceStatus.success.rawValue {
//
//                }
//                else {
//                    self.showError(error: data.msg)
//                }
//            }
//        }
//    }
//}
