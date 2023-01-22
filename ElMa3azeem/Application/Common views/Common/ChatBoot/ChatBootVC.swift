//
//  ChatBootVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 02/11/2022.
//

import UIKit

class ChatBootVC: UIViewController {

    @IBOutlet weak var chatTabaleView: UITableView!
    
    var array : [String] = ["welcome"]
    var homeCategory = [Category]()
    
    var selectedCategory : Category?
    var selectedStore : Store?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //setupStatusBar
        self.tabBarController?.hideTabbar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        registerTableViewCell()
    }
    
    func registerTableViewCell() {
        
        chatTabaleView.contentInset = UIEdgeInsets(top: 16 , left: 0, bottom: 16, right: 0)
        chatTabaleView.tableFooterView = UIView()
        chatTabaleView.delegate = self
        chatTabaleView.dataSource = self
        chatTabaleView.register(UINib(nibName: "WelcomeChatCell", bundle: nil), forCellReuseIdentifier: "WelcomeChatCell")
        chatTabaleView.register(UINib(nibName: "ChatBootCategoryCell", bundle: nil), forCellReuseIdentifier: "ChatBootCategoryCell")
        chatTabaleView.register(UINib(nibName: "SelectedCategotyCell", bundle: nil), forCellReuseIdentifier: "SelectedCategotyCell")
        chatTabaleView.register(UINib(nibName: "SelectStoreCell", bundle: nil), forCellReuseIdentifier: "SelectStoreCell")
        chatTabaleView.register(UINib(nibName: "SelectedStoreCell", bundle: nil), forCellReuseIdentifier: "SelectedStoreCell")
        chatTabaleView.register(UINib(nibName: "ChooseFromMenuBootCell", bundle: nil), forCellReuseIdentifier: "ChooseFromMenuBootCell")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.array.append("selectCategory")
            self.chatTabaleView.reloadData()
        }
    }
    
    //MARK: - Navigation
    func navigateToStore(storeID: Int) {
        let storyboard = UIStoryboard(name: StoryBoard.NormalOrder.rawValue , bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "StoreDetailsVC") as! StoreDetailsVC
        vc.storeID = storeID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSpecialRequest() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue , bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "SpecialRequestVC") as! SpecialRequestVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToParcelDelivery() {
        let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue , bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "ParcelDeliveryVC") as! ParcelDeliveryVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func restartBootAction(_ sender: Any) {
        array.removeAll()
        array.append("welcome")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.array.append("selectCategory")
            self.chatTabaleView.reloadData()
        }
        selectedCategory = nil
        selectedStore = nil
        chatTabaleView.reloadData()
    }
    
}


//MARK: - TableView Extension
extension ChatBootVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let welcomCell = tableView.dequeueReusableCell(withIdentifier: "WelcomeChatCell", for: indexPath) as! WelcomeChatCell
            welcomCell.configCell(userName: defult.shared.user()?.user?.name ?? "")
            return welcomCell
        }else if indexPath.row == 1 {
            
            let categoryCell = tableView.dequeueReusableCell(withIdentifier: "ChatBootCategoryCell", for: indexPath) as! ChatBootCategoryCell
            categoryCell.configCell(model: homeCategory)
            categoryCell.selectCategory = { [weak self] category in
                guard let self = self else {return}
                self.selectedCategory = category
                self.array.removeAll()
                self.array = ["welcome","selectCategory","selectedCategory"]
                self.chatTabaleView.reloadData()
            }
            
            if self.array.count > 4 {
                categoryCell.isUserInteractionEnabled = false
            }else{
                categoryCell.isUserInteractionEnabled = true
            }
            
            return categoryCell
            
        }else if indexPath.row == 2 {
            
            let selectedCategoryCell = tableView.dequeueReusableCell(withIdentifier: "SelectedCategotyCell", for: indexPath) as! SelectedCategotyCell
            
            selectedCategoryCell.configCell(title: selectedCategory?.name ?? "")
            
            if array.count == 3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.array.removeAll()
                    self.array = ["welcome","selectCategory","selectedCategory","selectStore"]
                    self.chatTabaleView.reloadData()
                }
            }
            
            return selectedCategoryCell
            
        } else if indexPath.row == 3 {
            
            let selectStoreCell = tableView.dequeueReusableCell(withIdentifier: "SelectStoreCell", for: indexPath) as! SelectStoreCell
            selectStoreCell.configCell(category: selectedCategory?.slug ?? "")
            
            selectStoreCell.chooseStore = { [weak self] in
                guard let self = self else {return}
                if self.selectedCategory?.slug == "parcel_delivery" {
                    self.navigateToParcelDelivery()
                }else if self.selectedCategory?.slug == "special_request" {
                    self.navigateToSpecialRequest()
                }else{
                    let storyboard = UIStoryboard(name: StoryBoard.Order.rawValue , bundle: nil)
                    let vc  = storyboard.instantiateViewController(withIdentifier: "StoresVC") as! StoresVC
                    vc.categoryid = "\(self.selectedCategory?.id ?? 0)"
                    vc.viewTitle = self.selectedCategory?.name ?? ""
                    vc.isFromChatBoot = true
                    vc.selectedStore = { [weak self] store in
                        guard let self = self else {return}
                        self.selectedStore = store
                        self.array.removeAll()
                        self.array = ["welcome","selectCategory","selectedCategory","selectStore","selectedCategory"]
                        self.chatTabaleView.reloadData()
                        selectStoreCell.isUserInteractionEnabled = false
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            
            if self.array.count > 4 {
                selectStoreCell.isUserInteractionEnabled = false
            }else{
                selectStoreCell.isUserInteractionEnabled = true
            }
            
            return selectStoreCell
        
        } else if indexPath.row == 4 {
            
            let selectedStoreCell = tableView.dequeueReusableCell(withIdentifier: "SelectedStoreCell", for: indexPath) as! SelectedStoreCell
            selectedStoreCell.configeCell(store: selectedStore)
            
            if array.count == 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.array.append("selectFromMenu")
                    self.chatTabaleView.reloadData()
                }
            }
            
            return selectedStoreCell
            
        } else if indexPath.row == 5 {
            
            let selectedStoreCell = tableView.dequeueReusableCell(withIdentifier: "ChooseFromMenuBootCell", for: indexPath) as! ChooseFromMenuBootCell
            
            selectedStoreCell.chooseFromMenu = { [weak self] in
                guard let self = self else {return}
                self.navigateToStore(storeID: self.selectedStore?.id ?? 0)
            }
            
            return selectedStoreCell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
