//
//  UserCommentVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 12/11/2022.
//

import UIKit

class UserCommentVC: BaseViewController {
    // MARK: - OutLets

    @IBOutlet weak var backAction: UIButton!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateCount: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var noDataLbl: UIStackView!
    @IBOutlet weak var contentStack: UIStackView!

    // MARK: - Properties

    var storeID = Int()
    var isFromMore = false
    private var reviewsData: [Review] = [] {
        didSet {
            commentTableView.reloadData()
        }
    }

    // MARK: - LifeCycle Events

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabbar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        starRatingView.isUserInteractionEnabled = false
        commentTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        loginAsVisitor { [weak self] in
            guard let self = self else { return }

            if self.isFromMore == true {
                guard let acountType = defult.shared.user()?.user?.accountType else { return }
                switch acountType {
                case .user:
                    self.getUserReviews()
                case .delegate:
                    self.setupUserRateView()
                    self.getUserReviews()
                case .provider:
                    self.getStoreReviews()
                case .unknown:
                    break
                }
            } else {
                self.getReviewsData(id: self.storeID)
            }
        }
        setupView()
    }

    func showNoData() {
        contentStack.isHidden = true
        commentTableView.isHidden = true
        noDataImage.isHidden = false
        noDataLbl.isHidden = false
    }

    func hideNoData() {
        contentStack.isHidden = false
        commentTableView.isHidden = false
        noDataImage.isHidden = true
        noDataLbl.isHidden = true
    }

    // MARK: - Logic

    func setupView() {
        tabBarController?.hideTabbar()
        commentTableView.tableFooterView = UIView()
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTableView.register(UINib(nibName: "UserCommentCell", bundle: nil), forCellReuseIdentifier: "UserCommentCell")
    }

    private func setupStoreRateView(model : ProviderStoreReviewsModel?) {
        hideNoData()
        rateCount.text = "(\(model?.numRating ?? ""))"
        rateLabel.text = model?.rate ?? ""
        starRatingView.rating = model?.rate.floatValue.rounded(.down) ?? 0
        reviewsData = model?.reviews ?? []
        commentTableView.reloadData()
    }
    
    private func setupUserRateView() {
        hideNoData()
        rateCount.text = "(\(defult.shared.user()?.user?.numComments ?? ""))"
        rateLabel.text = defult.shared.user()?.user?.rate ?? ""
        starRatingView.rating = defult.shared.user()?.user?.rate?.floatValue ?? 0
    }

    // MARK: - Networking

    func storeReviewsApi(id: Int, completion: @escaping (GeneralModel<ReviewsModel>?, Error?) -> Void) {
        var data: CallResponse<GeneralModel<ReviewsModel>> {
            return { response in
                switch response {
                case let .failure(error):
                    completion(nil, error)
                case let .success(items):
                    completion(items, nil)
                }
            }
        }
        CreateOrderNetworkRouter.storeReviews(id: String(id)).send(GeneralModel<ReviewsModel>.self, then: data)
    }

    func getReviewsData(id: Int) {
        showLoader()
        storeReviewsApi(id: id) { [weak self] data, error in
            self?.hideLoader()
            guard let self = self else { return }
            self.hideLoader()
            if let error = error {
                self.showError(error: error.localizedDescription)
            } else {
                guard let data = data else { return }
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.reviews.isEmpty == false {
                        self.reviewsData.append(contentsOf: data.data?.reviews ?? [])
                        self.commentTableView.reloadWithAnimation()
                        self.hideNoData()
                    } else {
                        self.showNoData()
                    }
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func getUserReviews() {
        showLoader()
        MoreNetworkRouter.userReviews.send(GeneralModel<ReviewsModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getUserReviews()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.reviews.isEmpty == false {
                        self.reviewsData.append(contentsOf: data.data?.reviews ?? [])
                        self.commentTableView.reloadWithAnimation()
                        self.hideNoData()
                    } else {
                        self.showNoData()
                    }
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    func getStoreReviews() {
        self.showLoader()
        ProviderMoreRouter.getStoreReviews.send(GeneralModel<ProviderStoreReviewsModel>.self) { [weak self] result in
            guard let self = self else {return}
            self.hideLoader()
            switch result {
            case .failure(let error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getStoreReviews()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case .success(let response):
                if response.key == ResponceStatus.success.rawValue {
                    self.setupStoreRateView(model: response.data)
                }else{
                    self.showError(error: response.msg)
                }
            }
        }
    }

    // MARK: - Actions

    @IBAction func backAction(_ sender: Any) {
        isFromMore = false
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Extension -

extension UserCommentVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCommentCell", for: indexPath) as! UserCommentCell
        cell.configCell(review: reviewsData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
