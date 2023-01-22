//
//  ChatVC.swift
//  ElMa3azeem
//
//  Created by Mustafa Abdein on 16/01/2022.
//

import AVFoundation
import AVKit
import GoogleMaps
import IQKeyboardManagerSwift
import MapKit
import MobileCoreServices
import SocketIO
import UIKit

// import DropDown

class ChatVC: BaseViewController {
    @IBOutlet weak var activityIndicatior   : UIActivityIndicatorView!
    @IBOutlet weak var tableView            : UITableView!
    @IBOutlet weak var noResultLabel        : UILabel!

    @IBOutlet weak var heightBottomViewConstraint: NSLayoutConstraint! /// 105
    @IBOutlet weak var msgTV                : UITextView!

    @IBOutlet weak var cameraBtn            : UIButton!
    @IBOutlet weak var recordBtn            : UIButton!
    @IBOutlet weak var sendBtn              : UIButton!

//    @IBOutlet weak var widthRecordViewCOnstraint: NSLayoutConstraint!
//    @IBOutlet weak var recordView: UIView!
//    @IBOutlet weak var cancelRecordBtn: UIButton!
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var micImageView: UIImageView!

    @IBOutlet weak var chatView             : UIView!

    @IBOutlet weak var bottomChatViewConstraint: NSLayoutConstraint!

    var recieverId  : Int?
    var roomID      : Int?
    var senderId    : Int?
    var orderState  : OrderStatus = .finished
    var dataSource  = [MessageModel]()
    var dataLoaded  = false

    var conversationDetails: Room?

    // image
    var selectedImage       : UIImage?
    var selectedDataImage   : Data?
    var isImageSelected     = false

    var avatar = defult.shared.user()?.user?.avatar

    var audioRecorder       : AVAudioRecorder!

    var isAudioSelected     = false
    var audioDatRecorded    : Data?
//    var audioPlayer:AVAudioPlayer!

    var recordMode          : RecordMode = .notRecording
    var counter             = 0
    var timer               = Timer()
//    var isPlaying = false

    var scroll          = false
    var nextPage        = 1
    var fetchingData    = false

    var session         = AVAudioSession.sharedInstance()
    var recordPlayer    : AVPlayer?
    var selectedRecordIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        if orderState == .finished {
            chatView.isHidden = true
        } else {
            chatView.isHidden = false
        }
        configureSocket()
        recordBtn.tintColor = UIColor.appColor(.SecondFontColor)
//        initialTitleView(title: recieverName ?? "",userImage: recieverImage ?? "")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            session.requestRecordPermission { [unowned self] _ in
//                DispatchQueue.main.async {
//                    if allowed {
//                        self.havePerrmission = true
//                    } else {
//                        // failed to record!
//                    }
//                }
            }
        } catch {
            // failed to record!
        }
        msgTV.delegate = self
        msgTV.text = "Write Your Message Here".localized
        msgTV.textColor = .appColor(.placeHolderColor)
        msgTV.contentInset = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.register(UINib(nibName: "MessageTextTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageTextTableViewCell")
        tableView.register(UINib(nibName: "MessageImageTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageImageTableViewCell")
        tableView.register(UINib(nibName: "MessageRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "MessageRecordTableViewCell")

        getData(isAppending: false, page: nextPage)
    }

    override func viewWillAppear(_ animated: Bool) {
        // setupStatusBar
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        SocketConnection.sharedInstance.socket.emit("exitChat", with: []) {}
        SocketConnection.sharedInstance.socket.off("newMessage")

        NotificationCenter.default.removeObserver(#selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(#selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        do {
            try session.setActive(false)
            recordPlayer?.pause()
        } catch {
            print("error in deactivating session: \(error.localizedDescription)")
        }
    }

    @objc func keyboardWillShow(notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height

        // do whatever you want with this keyboard height
        bottomChatViewConstraint.constant = keyboardHeight + 8
        //        self.scrollToBottom()
        view.layoutIfNeeded()
    }

    @objc func keyboardWillHide(notification: Notification) {
        // keyboard is dismissed/hidden from the screen
        bottomChatViewConstraint.constant = 8
        view.layoutIfNeeded()
    }

    @objc func onNotification(notification: Notification) {
//        let info = notification.userInfo
//        if let conversation = info?["data"] as? WatsChatConversation ,let conversationDetails = self.conversationDetails {
//            if conversation.conversationID == conversationDetails.conversationID {
//                self.conversationDetails = conversation
//                self.setData()
//            }
//        }
    }

    @IBAction func sendBtnPressed(_ sender: Any) {
        if dataLoaded {
            guard let message = msgTV.text, !(msgTV.text?.isEmpty)! else { return showMessage(sub: "You Can't Send Empty Message".localized, type: .error) }

            if message == "Write Your Message Here".localized {
                return showMessage(sub: "You Can't Send Empty Message".localized, type: .error)
            }

            sendMessageInSocket(message: message, type: "text", duration: "00.00", avatar: avatar ?? "")
        }
    }

    @IBAction func cameraBtnPressed(_ sender: Any) {
        uploadImage(mediaType: [mediaTypes.publicImage.rawValue])
    }

    func sendMessageInSocket(message: String, type: String, duration: String, avatar: String) {
        let dic = [
            "sender_id": defult.shared.user()?.user?.id ?? 0,
            "room_id": roomID ?? 0,
            "receiver_id": recieverId!,
            "type": type,
            "content": message,
            "duration": duration,
            "avatar": avatar,

        ] as [String: Any]

        SocketConnection.sharedInstance.socket.emit("sendMessage", with: [dic]) {
            print(dic)
        }

        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        let timeNow = "\(formatter.string(from: currentDateTime))"
        let msg = Message(id: 0, content: message, avatar: "", type: type, date: "", time: timeNow, sentByMe: true, duration: (duration as NSString).doubleValue)

        UIView.animate(withDuration: 0.5) {
            self.msgTV.text = ""
            self.dataSource.insert(MessageModel(imageFromMe: nil, msg: msg), at: 0)
            self.tableView.reloadData()
        }

        noResultLabel.isHidden = dataSource.count > 0
    }

    @IBAction func recordBtnPressed(_ sender: UIButton) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            let storyboard = UIStoryboard(name: StoryBoard.Chat.rawValue, bundle: nil)
            let popOver = storyboard.instantiateViewController(withIdentifier: "RecordViewController") as! RecordViewController
            popOver.preferredContentSize = CGSize(width: 250, height: 60)
            popOver.modalPresentationStyle = .popover
            popOver.voiceNoteDelegate = self
            if let popOverPresentaion = popOver.popoverPresentationController {
                popOverPresentaion.permittedArrowDirections = .down
                popOverPresentaion.sourceView = sender
                popOverPresentaion.sourceRect = sender.bounds
                popOverPresentaion.delegate = self
                present(popOver, animated: true)
            }
            break

        default:

            let alert = UIAlertController(title: "", message: "noRecordPermission".localized, preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "settings".localized, style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { success in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            let cancelAction = UIAlertAction(title: "cancel".localized, style: .default, handler: nil)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func configureSocket() {
        SocketConnection.sharedInstance.socket.connect()
        let dic = [
            "user_id": senderId!,
            "room_id": roomID ?? 0,
        ] as [String: Any]

        SocketConnection.sharedInstance.socket.emit("adduser", with: [dic]) {
            print("added user id \(dic)")
        }

        SocketConnection.sharedInstance.socket.on(clientEvent: .statusChange) { _, _ in
            print("status    \(SocketConnection.sharedInstance.socket.status)")
            if SocketConnection.sharedInstance.socket.status == .connected {
                print("reconnected    \(SocketConnection.sharedInstance.socket.status)")
                let dic = [
                    "user_id": self.senderId!,
                    "room_id": self.roomID ?? 0,
                ] as [String: Any]
                SocketConnection.sharedInstance.socket.emit("adduser", with: [dic]) {
                    print("added user id \(dic)")
                }
            }
        }

        SocketConnection.sharedInstance.socket.on("newMessage") { value, _ in
            print(value)
            self.gotMessage(value: value)
        }
    }

    func getData(isAppending: Bool, page: Int) {
        if let roomID = roomID {
            showLoader()
            ChatNetworkRouter.room(room_id: roomID, page: page).send(ChatResponse.self) {
                [weak self] response in
                self?.hideLoader()
                guard let self = self else { return }
                switch response {
                case let .failure(error):
                    if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                        self.showNoInternetConnection { [weak self] in
                            self?.getData(isAppending: false, page: self?.nextPage ?? 1)
                        }
                    } else {
                        self.showError(error: error.localizedDescription)
                    }
                case let .success(value):
                    if value.key == ResponceStatus.success.rawValue {
                        self.conversationDetails = value.data.room
                        self.dataLoaded = true
                        self.roomID = value.data.room.id

                        let messages = value.data.room.messages

                        if !isAppending {
                            self.dataSource = []
                            for message in messages {
                                self.dataSource.append(MessageModel(imageFromMe: nil, videoFromMe: nil, msg: message))
                            }

                        } else {
                            for message in messages {
                                self.dataSource.append(MessageModel(imageFromMe: nil, videoFromMe: nil, msg: message))
                            }
                        }

                        self.nextPage = value.data.room.pagination.currentPage + 1
                        self.nextPage = self.nextPage > value.data.room.pagination.totalPages ? 0 : self.nextPage
                        print("nextPage:\(self.nextPage)")

                        if self.dataSource.count == 0 {
                            self.scroll = false
                        } else if self.dataSource.count > 0 {
                            self.scroll = true
                        }
                        if self.dataSource.count > 0 {
                            self.noResultLabel.isHidden = true
                        } else {
                            self.noResultLabel.isHidden = false
                        }

                        self.tableView.reloadData()
                        self.fetchingData = false
                    } else {
                        self.showError(error: value.msg)
                    }
                }
            }
        }
    }

    func uploadImg() {
        var uploadData = [UploadData]()
        if isImageSelected {
            uploadData.append(UploadData(data: selectedDataImage!, fileName: "Image.jpg", mimeType: "image/jpg", name: "file"))
        }
        startAnimating()
        ChatNetworkRouter.uploadFile(type: "image", duration: "0").send(chatFileResponse.self, data: uploadData) { [weak self] response in
            self?.stopAnimating()
            guard let self = self else { return }
            switch response {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self.showNoInternetConnection { [weak self] in
                        self?.uploadImg()
                    }
                } else {
                    self.showError(error: error.localizedDescription)
                }
            case let .success(value):
                if value.key == ResponceStatus.success.rawValue {
                    self.sendMessageInSocket(message: value.data.url, type: "image", duration: "00.00", avatar: self.avatar ?? "")
                } else {
                    self.showError(error: value.msg)
                }
            }
        }
    }

    func uploadRecord(record: Data, duration: Double) {
        var uploadedData = [UploadData]()
        uploadedData.append(UploadData(data: record, fileName: "record.m4a", mimeType: "audio/m4a", name: "file"))

        startAnimating()
        ChatNetworkRouter.uploadFile(type: "file", duration: "\(duration)").send(chatFileResponse.self, data: uploadedData) { [weak self] response in
            self?.stopAnimating()
            switch response {
            case let .failure(error):
                if error.localizedDescription == APIConnectionErrors.connection.localizedDescription {
                    self?.showNoInternetConnection { [weak self] in
                        self?.uploadRecord(record: record, duration: duration)
                    }
                } else {
                    self?.showError(error: error.localizedDescription)
                }
            case let .success(value):
                if value.key == ResponceStatus.success.rawValue {
                    self?.sendMessageInSocket(message: value.data.name, type: "sound", duration: value.data.duration, avatar: self?.avatar ?? "")
                } else {
                    self?.showError(error: value.msg)
                }
            }
        }
    }

    func gotMessage(value: [Any]) {
        print("got value from socket \(value)")
        if value.count > 0 {
            let msgResponse = value[0] as! [String: Any]

            do {
                let decoder = JSONDecoder()
                let jsonData = try JSONSerialization.data(withJSONObject: msgResponse, options: .prettyPrinted)

                let msg = try decoder.decode(MessageSocketModel.self, from: jsonData)
                
                let time = "One Second Ago".localized
                if msg.roomID == roomID {
                    UIView.animate(withDuration: 0.5) {
                        if msg.type == "text" {
                            let message = Message(id: 0, content: msg.content, avatar: "", type: msg.type, date: "", time: time, sentByMe: false, duration: 0)
                            self.dataSource.insert(MessageModel(msg: message), at: 0)
                        }else if msg.type == "sound" {
                            let message = Message(id: 0, content: msg.content, avatar: "", type: msg.type, date: "", time: time, sentByMe: false, duration: Double(msg.duration ?? "") ?? 0)
                            self.dataSource.insert(MessageModel(msg: message), at: 0)
                        }else{
                            let message = Message(id: 0, content: msg.content, avatar: "", type: msg.type, date: "", time: time, sentByMe: false, duration: 0)
                            self.dataSource.insert(MessageModel(msg: message), at: 0)
                        }
                        
                        self.tableView.reloadData()
                    }
                    if dataSource.count > 0 {
                        noResultLabel.isHidden = true
                    } else {
                        noResultLabel.isHidden = false
                    }
                }
            } catch {
            }
        }
    }

    func showFullScreen(url: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "FullImageVC") as! FullImageVC
        vc.imageUrl = url
        present(vc, animated: true, completion: nil)
    }

    @IBAction func didSelectDeliveryPolicyBu(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryBoard.More.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionsVC") as! TermsAndConditionsVC
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChatVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let width = msgTV.frame.width
        let size = CGSize(width: Double(width), height: Double.greatestFiniteMagnitude)
        let estimatedHeight = textView.sizeThatFits(size)
        if estimatedHeight.height > CGFloat(40.0) {
            heightBottomViewConstraint.constant = estimatedHeight.height + 16.0 + 24.0
        } else {
            UIView.animate(withDuration: 0.2) {
                self.heightBottomViewConstraint.constant = 80.0
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if msgTV.text == "Write Your Message Here".localized {
            msgTV.text = ""
            msgTV.textColor = .appColor(.placeHolderColor)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if msgTV.text == "" {
            msgTV.text = "Write Your Message Here".localized
            msgTV.textColor = .appColor(.placeHolderColor)
        }
    }
}

extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let imageData: Data = ((picker.sourceType == .camera) ? image.fixedOrientation() : image).pngData()! as Data
            isImageSelected = true
            selectedImage = image
            selectedDataImage = imageData

            uploadImg()

        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageData: Data = ((picker.sourceType == .camera) ? image.fixedOrientation() : image).pngData()! as Data
            isImageSelected = true
            selectedImage = image
            selectedDataImage = imageData

            uploadImg()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ChatVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension ChatVC: VoiceNoteDelegate {
    func updateWithVoiceNote(record: Data, duration: Double) {
        uploadRecord(record: record, duration: duration)
    }
}

extension Date {
    static func - (recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }
}

extension UIImage {
    func fixedOrientation() -> UIImage {
        // No-op if the orientation is already correct
        if imageOrientation == UIImage.Orientation.up {
            return self
        }

        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity

        if imageOrientation == UIImage.Orientation.down
            || imageOrientation == UIImage.Orientation.downMirrored {
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }

        if imageOrientation == UIImage.Orientation.left
            || imageOrientation == UIImage.Orientation.leftMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        }

        if imageOrientation == UIImage.Orientation.right
            || imageOrientation == UIImage.Orientation.rightMirrored {
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
        }

        if imageOrientation == UIImage.Orientation.upMirrored
            || imageOrientation == UIImage.Orientation.downMirrored {
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }

        if imageOrientation == UIImage.Orientation.leftMirrored
            || imageOrientation == UIImage.Orientation.rightMirrored {
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                       bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: cgImage!.colorSpace!,
                                       bitmapInfo: cgImage!.bitmapInfo.rawValue)!

        ctx.concatenate(transform)

        if imageOrientation == UIImage.Orientation.left
            || imageOrientation == UIImage.Orientation.leftMirrored
            || imageOrientation == UIImage.Orientation.right
            || imageOrientation == UIImage.Orientation.rightMirrored {
            ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))

        } else {
            ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }

        // And now we just create a new UIImage from the drawing context
        let cgimg: CGImage = ctx.makeImage()!
        let imgEnd: UIImage = UIImage(cgImage: cgimg)

        return imgEnd
    }
}

enum RecordMode {
    case notRecording
    case recording
}
