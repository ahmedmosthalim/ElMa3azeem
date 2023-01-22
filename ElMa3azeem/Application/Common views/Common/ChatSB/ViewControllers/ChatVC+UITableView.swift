//
//  ChatVC+UITableView.swift
//  ElMa3azeem
//
//  Created by Mustafa Abdein on 18/01/2022.
//

import AVKit
import UIKit

extension ChatVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]

        if item.msg.type == "text" {
            guard let textCell = tableView.dequeueReusableCell(withIdentifier: "MessageTextTableViewCell", for: indexPath) as? MessageTextTableViewCell else {
                return UITableViewCell()
            }

            textCell.transform = CGAffineTransform(scaleX: 1, y: -1)

            textCell.configureCell(message: dataSource[indexPath.row].msg)

            if item.msg.sentByMe {
                textCell.transform = CGAffineTransform(scaleX: 1, y: -1)
                textCell.cellBackgroundLeading.constant = 20
                textCell.cellBackgroundTrailing.constant = view.bounds.width / 2 - 100
                textCell.isSeen.transform = CGAffineTransform(scaleX: 1, y: 1)
                textCell.messageDate.transform = CGAffineTransform(scaleX: 1, y: 1)
                textCell.message.textAlignment = .right
                textCell.messageDate.textAlignment = .right
                textCell.cellBackground.backgroundColor = UIColor.appColor(.mainColorWithAlpha)
                textCell.message.textColor = .black
            } else {
                textCell.transform = CGAffineTransform(scaleX: 1, y: -1)
                textCell.cellBackgroundTrailing.constant = 20
                textCell.cellBackgroundLeading.constant = view.bounds.width / 2 - 100
                textCell.isSeen.transform = CGAffineTransform(scaleX: 1, y: 1)
                textCell.messageDate.transform = CGAffineTransform(scaleX: 1, y: 1)
                textCell.message.textAlignment = .left
                textCell.messageDate.textAlignment = .left
                textCell.cellBackground.backgroundColor = UIColor.appColor(.BackGroundCell)
                textCell.message.textColor = .black
            }

            return textCell

        } else if item.msg.type == "image" {
            guard let imageCell = tableView.dequeueReusableCell(withIdentifier: "MessageImageTableViewCell", for: indexPath) as? MessageImageTableViewCell else {
                return UITableViewCell()
            }

            imageCell.transform = CGAffineTransform(scaleX: 1, y: -1)

            imageCell.configureImageCell(message: dataSource[indexPath.row].msg)

            if item.msg.sentByMe {
                imageCell.cellBackgroundLeading.constant = 20
                imageCell.cellBackgroundTrailing.constant = view.bounds.width / 2 - 100
                imageCell.backGroundView.backgroundColor = UIColor.appColor(.mainColorWithAlpha)
                //                imageCell.message.textColor = .black
            } else {
                imageCell.cellBackgroundTrailing.constant = 20
                imageCell.cellBackgroundLeading.constant = view.bounds.width / 2 - 100
                imageCell.backGroundView.backgroundColor = UIColor.appColor(.BackGroundCell)
                //            imageCell.message.textColor = .black
            }

            return imageCell
        } else if item.msg.type == "sound" {
            guard let recordCell = tableView.dequeueReusableCell(withIdentifier: "MessageRecordTableViewCell", for: indexPath) as? MessageRecordTableViewCell else { return UITableViewCell() }

            recordCell.transform = CGAffineTransform(scaleX: 1, y: -1)

            recordCell.configureCell(message: dataSource[indexPath.row].msg)

            if item.msg.sentByMe {
                recordCell.cellBackgroundLeading.constant = 20
                recordCell.cellBackgroundTrailing.constant = view.bounds.width / 2 - 100
                recordCell.cellBackground.backgroundColor = UIColor.appColor(.mainColorWithAlpha)
//                recordCell.playerView.backgroundColor = UIColor.appColor(.myMessageChatColor)
                //                recordCell.message.textColor = .black
            } else {
                recordCell.cellBackgroundTrailing.constant = 20
                recordCell.cellBackgroundLeading.constant = view.bounds.width / 2 - 100
                recordCell.cellBackground.backgroundColor = UIColor.appColor(.BackGroundCell)
//                recordCell.playerView.backgroundColor = UIColor.appColor(.otherMessageChatColor)
                //                recordCell.message.textColor = .black
            }

            recordCell.playAction = {
                if indexPath.row == self.selectedRecordIndex {
                    if recordCell.playerView.player?.timeControlStatus == .paused {
                        recordCell.playerView.player?.play()
                        recordCell.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                        recordCell.isFinished = false
                        if recordCell.isFinished == true {
                            print("seek")
                            recordCell.playerView.player?.seek(to: CMTime(seconds: 0.0, preferredTimescale: CMTimeScale.max))
                        }
                        recordCell.playButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControl.State.normal)
                        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { t in
                            if recordCell.playButton.imageView?.image == #imageLiteral(resourceName: "pause") {
                                if recordCell.playerView.player?.status == .readyToPlay {
                                    recordCell.updateVideoPlayerSlider()
                                }
                            }
                            // if video finished stop timer
                            if recordCell.isFinished {
                                // stop timer
                                print("stop here")
                                recordCell.playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
                                recordCell.record.value = 0.0
                                recordCell.playerView.player?.seek(to: CMTime(seconds: 0.0, preferredTimescale: CMTimeScale.max))
                                recordCell.playerView.player?.pause()
                                recordCell.PlayTimeLabel.text = "00:00"
                                recordCell.isFinished = false
                                t.invalidate()
                            }
                        })
                    } else if recordCell.playerView.player?.timeControlStatus == .none {
                        self.recordPlayer = AVPlayer(url: URL(string: item.msg.content)!)
                        recordCell.sliderView.value = 0
                        recordCell.PlayTimeLabel.text = "00:00"
                        recordCell.playerView.player = self.recordPlayer
                        recordCell.playerView.player?.play()
                        recordCell.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                        recordCell.isFinished = false
                        if recordCell.isFinished == true {
                            print("seek")
                            recordCell.playerView.player?.seek(to: CMTime(seconds: 0.0, preferredTimescale: CMTimeScale.max))
                        }
                        recordCell.playButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControl.State.normal)
                        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { t in
                            if recordCell.playButton.imageView?.image == #imageLiteral(resourceName: "pause") {
                                if recordCell.playerView.player?.status == .readyToPlay {
                                    recordCell.updateVideoPlayerSlider()
                                }
                            }
                            // if video finished stop timer
                            if recordCell.isFinished {
                                // stop timer
                                print("stop here")
                                recordCell.playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
                                recordCell.record.value = 0.0
                                recordCell.playerView.player?.seek(to: CMTime(seconds: 0.0, preferredTimescale: CMTimeScale.max))
                                recordCell.playerView.player?.pause()
                                recordCell.PlayTimeLabel.text = "00:00"
                                recordCell.isFinished = false
                                t.invalidate()
                            }
                        })
                    } else if recordCell.playerView.player?.timeControlStatus == .playing {
                        recordCell.playerView.player?.pause()
                        recordCell.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                    } else {
                        recordCell.playerView.player?.pause()
                        recordCell.playButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                    }
                } else {
                    recordCell.playButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                    recordCell.sliderView.value = 0
                    recordCell.PlayTimeLabel.text = "00:00"
                    if self.selectedRecordIndex != nil, let selectedIndex = self.selectedRecordIndex {
                        tableView.reloadRows(at: [IndexPath(row: selectedIndex, section: 0)], with: .none)
                    }

                    if let index = self.selectedRecordIndex {
                        (tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MessageRecordTableViewCell)?.playButton.imageView?.image = #imageLiteral(resourceName: "play")
                    }

                    self.selectedRecordIndex = indexPath.row
                    self.recordPlayer?.pause()
                    self.recordPlayer = nil
                    recordCell.playerView.player = nil
                    self.recordPlayer = AVPlayer(url: URL(string: self.dataSource[indexPath.row].msg.content)!)
                    recordCell.playerView.player = self.recordPlayer
                    recordCell.playerView.player?.play()
                    print("record url: \(self.dataSource[indexPath.row].msg.content)")
                    recordCell.isFinished = false

                    if recordCell.isFinished == true {
                        recordCell.playerView.player?.seek(to: CMTime(seconds: 0.0, preferredTimescale: CMTimeScale.max))
                    }

                    recordCell.playButton.setImage(#imageLiteral(resourceName: "pause"), for: UIControl.State.normal)
                    _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { t in
                        if recordCell.playButton.imageView?.image == #imageLiteral(resourceName: "pause") {
                            if recordCell.playerView.player?.status == .readyToPlay {
                                recordCell.updateVideoPlayerSlider()
                            }
                        }
                        // if video finished stop timer
                        if recordCell.isFinished {
                            // stop timer
                            print("stop here")
                            recordCell.playButton.setImage(#imageLiteral(resourceName: "play"), for: UIControl.State.normal)
                            recordCell.record.value = 0.0
                            recordCell.playerView.player?.seek(to: CMTime(seconds: 0.0, preferredTimescale: CMTimeScale.max))
                            recordCell.playerView.player?.pause()
                            recordCell.PlayTimeLabel.text = "00:00"
                            recordCell.isFinished = false
                            t.invalidate()
                        }
                    })
                }
            }

            return recordCell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if nextPage != 0 && (indexPath.row == dataSource.count - 1) && scroll && !fetchingData {
            getData(isAppending: true, page: nextPage)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        if item.msg.type == "image" {
            showFullScreen(url: item.msg.content)
        }
    }
}
