//
//  StoreSettingVC+WorkTime.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 04/11/2022.
//

import Foundation
import UIKit

// MARK: - TableView Extension

extension StoreSettingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (providerData?.openingHours.count ?? 0) + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: StoreWorkTimeCell.self, for: indexPath) as! StoreWorkTimeCell

        if indexPath.row == 0 {
            cell.configFiristCell()
        } else {
            cell.configCell(time: providerData?.openingHours[indexPath.row - 1])
        }

        cell.addTimeTapped = { [weak self] day, fromTime, toTime in
            guard let self = self else { return }

//            if (self.providerData?.openingHours.first(where: { $0.id == day.pickerId })) != nil {
//                self.showError(error: "This day was added before".localized)
//            } else {
                self.providerData?.openingHours.append(OpeningHour(id: day.pickerId, key: day.pickerKey, day: day.pickerTitle, from: fromTime, to: toTime))
                self.providerData?.openingHours.sort(by: { $0.id ?? 0 < $1.id ?? 0 })
                tableView.reloadData()
//            }
        }

        cell.deleteTimeTapped = { [weak self] in
            guard let self = self else { return }
            self.view.endEditing(true)
            self.providerData?.openingHours.remove(at: indexPath.row - 1)
            tableView.reloadData()
        }

        cell.errorSelecting = { [weak self] errorMessage in
            guard let self = self else { return }
            self.showError(error: errorMessage)
        }

        cell.updateDay = { [weak self] selectedDay in
            guard let self = self else { return }
            if indexPath.row > 0 {
                if (self.providerData?.openingHours.first(where: { $0.id == selectedDay.pickerId })) != nil {
                    self.showError(error: "This day was added before".localized)
                } else {
                    self.providerData?.openingHours[indexPath.row - 1].id = selectedDay.pickerId
                    self.providerData?.openingHours[indexPath.row - 1].day = selectedDay.pickerTitle
                    self.providerData?.openingHours[indexPath.row - 1].key = selectedDay.pickerKey

                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        cell.updateFromDate = { [weak self] fromTime in
            guard let self = self else { return }
            if indexPath.row > 0 {
                self.providerData?.openingHours[indexPath.row - 1].fromTime = fromTime
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        cell.updateToDate = { [weak self] toTime in
            guard let self = self else { return }
            if indexPath.row > 0 {
                self.providerData?.openingHours[indexPath.row - 1].toTime = toTime
                tableView.reloadRows(at: [indexPath], with: .automatic)
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
}
