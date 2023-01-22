//
//  ComplaintsVC.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 11/11/2022.
//

import UIKit

class ComplaintsVC: BaseViewController {
    // MARK: - OutLets

    @IBOutlet weak var complaintsTableView: UITableView!
    @IBOutlet weak var noDatatImage: UIImageView!
    @IBOutlet weak var noDataMessage: UIStackView!

    // MARK: - Properties

    private var ticketsArray: [Ticket] = []

    // MARK: - LifeCycle Events

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.hideTabbar()
        setupView()
        complaintsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        loginAsVisitor { [weak self] in
            guard let self = self else { return }
            self.getTicketsApi()
        }
    }

    // MARK: - Logic

    func setupView() {
        complaintsTableView.tableFooterView = UIView()
        complaintsTableView.delegate = self
        complaintsTableView.dataSource = self
        complaintsTableView.register(UINib(nibName: "ComplaintsCell", bundle: nil), forCellReuseIdentifier: "ComplaintsCell")
    }

    func navigateToDetails(id: Int) {
        let storyboard = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ComplaintDetailsVC") as! ComplaintDetailsVC
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Networking

    func getTicketsApi() {
        showLoader()
        MoreNetworkRouter.getTicket.send(GeneralModel<TicketModel>.self) { [weak self] result in
            guard let self = self else { return }
            self.hideLoader()
            switch result {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.getTicketsApi()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(data):
                if data.key == ResponceStatus.success.rawValue {
                    if data.data?.tickets.isEmpty == true {
                        self.noDatatImage.isHidden = false
                        self.noDataMessage.isHidden = false
                        self.complaintsTableView.isHidden = true
                    } else {
                        self.ticketsArray.append(contentsOf: data.data?.tickets ?? [])
                        self.complaintsTableView.isHidden = false
                        self.noDatatImage.isHidden = true
                        self.noDataMessage.isHidden = true
                        self.complaintsTableView.reloadData()
                    }
                } else {
                    self.showError(error: data.msg)
                }
            }
        }
    }

    // MARK: - Actions

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView Extension

extension ComplaintsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComplaintsCell", for: indexPath) as! ComplaintsCell
        cell.configCell(item: ticketsArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "More", bundle: nil).instantiateViewController(withIdentifier: "ComplaintDetailsVC") as! ComplaintDetailsVC
        vc.ticketId = ticketsArray[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
