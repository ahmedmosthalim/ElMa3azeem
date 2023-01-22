//
//  ComplaintDetailsVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 13/11/2022.
//

import UIKit

class ComplaintDetailsVC: BaseViewController {

    //MARK: - OutLets
    ///store data
    @IBOutlet weak var sotreImage: UIImageView!
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var orderNameLbl: UILabel!
    @IBOutlet weak var orderTimeLbl: UILabel!

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNAme: UILabel!
    
    @IBOutlet weak var complaintNumber: UILabel!
    @IBOutlet weak var complaintDate: UILabel!
    @IBOutlet weak var complaintDetails: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var complaintImageStack: UIStackView!
    
    //MARK: - Properties
    private var SignleTicketArray: [Image] = [] {
        didSet {
            imageCollectionView.reloadData()
        }
    }
    var ticketId = Int()
    
    
    //MARK: - LifeCycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        singleTicketApi()
    }
    
    //MARK: - Logic
    func setupView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(UINib(nibName: "ComplaintDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ComplaintDetailsCell")
    }
    
    //MARK: - Networking
    func singleTicketApi() {
        self.showLoader()
        MoreNetworkRouter.singleTicket(ticketId: ticketId).send(GeneralModel<SignleTicketModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.singleTicketApi()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let data):
                if data.key == ResponceStatus.success.rawValue {
                    self.sotreImage.setImage(image: data.data?.ticket.order.image ?? "")
                    self.orderNumberLbl.text = "\(data.data?.ticket.order.id ?? 0)"
                    self.orderNameLbl.text = data.data?.ticket.order.name ?? ""
                    self.orderTimeLbl.text = data.data?.ticket.order.createdAt  ?? ""
                    
                    self.userImage.setImage(image: data.data?.ticket.otherMemberAvatar ?? "")
                    self.userNAme.text = data.data?.ticket.otherMemberName
                    
                    self.complaintNumber.text = "\(data.data?.ticket.id ?? 0)"
                    self.complaintDate.text = data.data?.ticket.createdAt
                    self.complaintDetails.text = data.data?.ticket.text
                    
                    if data.data?.ticket.images.isEmpty == false {
                        self.SignleTicketArray = data.data?.ticket.images ?? []
                        self.complaintImageStack.isHidden = false
                    }else{
                        self.complaintImageStack.isHidden = true
                    }
                }else{
                    self.showError(error: data.msg)
                }
            }
        }
    }
    
    //MARK: - Actions
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Collection View Extension
extension ComplaintDetailsVC: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SignleTicketArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComplaintDetailsCell", for: indexPath) as! ComplaintDetailsCell
        cell.configerCellWithUrl(image: SignleTicketArray[indexPath.row].url, deletable: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FullImageVC") as! FullImageVC
        vc.imageUrl = SignleTicketArray[indexPath.row].url
        self.present(vc, animated: true, completion: nil)
        
        return collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
}
