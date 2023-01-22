//
//  ProviderFinanceVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 21/11/2022.
//

import UIKit

class ProviderFinanceVC: BaseViewController {
    
    @IBOutlet weak var walletBtn            : RoundedButton!
    @IBOutlet weak var statusBtn            : RoundedButton!
    @IBOutlet weak var mainViewBackGround   : UIView!
    @IBOutlet weak var emptyStack           : UIStackView!
    
    // walet outlets
    @IBOutlet weak var walletView           : UIView!
    @IBOutlet weak var balaceLbl            : UILabel!
    @IBOutlet weak var currncyLbl           : UILabel!

    // financial statistics outlet
    @IBOutlet weak var financeTableView: IntrinsicTableView!
    
    var storeFinanceArray = [StoreFinanceModel]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - CONFIGRATION

    private func tableViewConfigration() {
        financeTableView.delegate = self
        financeTableView.dataSource = self
        financeTableView.registerCell(type: ProviderFinanceCell.self)
    }

    private func setupView() {
        selectWallet()
        getStoreFinance()
        getCurrentBalanceAPi()
        tableViewConfigration()
    }

    // MARK: - LOGIC

    private func selectWallet() {
        walletBtn.selectButton()
        statusBtn.notSelectButton()
        walletView.isHidden = false
        emptyStack.isHidden = true
        financeTableView.isHidden = true
        mainViewBackGround.backgroundColor = .appColor(.viewBackGround)
    }

    private func selectFinance() {
        statusBtn.selectButton()
        walletBtn.notSelectButton()
        walletView.isHidden = true
        
        if storeFinanceArray.count == 0
        {
            emptyStack.isHidden = false
            financeTableView.isHidden = true
        }else
        {
            financeTableView.isHidden = false

        }
        mainViewBackGround.backgroundColor = .clear
    }

    // MARK: - NAVIGATION

    // MARK: - ACTIONS

    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func walletAction(_ sender: Any) {
        selectWallet()
    }

    @IBAction func financeAction(_ sender: Any) {
        selectFinance()
    }

    @IBAction func rechargeWallet(_ sender: Any) {
        showError(error: "This action not avilable right now")
    }
}

//MARK: - TableView Extension
extension ProviderFinanceVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeFinanceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType:  ProviderFinanceCell.self, for: indexPath) as! ProviderFinanceCell
        cell.configCell(model: storeFinanceArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryBoard.ProviderOrder.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProviderOrderDetailsVC") as! ProviderOrderDetailsVC
        vc.orderID = storeFinanceArray[indexPath.row].orderID
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - API

extension ProviderFinanceVC {
    func getCurrentBalanceAPi() {
        showLoader()
        MoreNetworkRouter.wallet.send(WalletModel.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getCurrentBalanceAPi()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    self.balaceLbl.text = data.data.wallet
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }
    
    func getStoreFinance() {
        self.showLoader()
        ProviderMoreRouter.getStoreFinance.send(GeneralModel<[StoreFinanceModel]>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getStoreFinance()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let response):
                if response.key == ResponceStatus.success.rawValue {
                    self.storeFinanceArray = response.data ?? []
                    self.financeTableView.reloadData()
                }else{
                    self.showError(error: response.msg)
                }
            }
        }
    }
    
}
