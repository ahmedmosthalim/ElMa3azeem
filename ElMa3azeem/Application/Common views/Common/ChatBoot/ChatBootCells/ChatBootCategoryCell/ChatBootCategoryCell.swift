//
//  ChatBootCategoryCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 02/11/2022.
//

import UIKit
import Lottie
 

class ChatBootCategoryCell: UITableViewCell {

    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var categoryTableView: IntrinsicTableView!
    @IBOutlet weak var animationView: LottieAnimationView!
    
    var categoryArray = [Category]()
    var selectCategory : ((_ categoty:Category)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        backGroundView.isHidden = true
        setupAnimationView()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        tableViewConfigration()
        
        if Language.isArabic() {
            backGroundView.setupChatBootStyleArabic()
            animationView.setupChatBootStyleArabic()
        }else{
            backGroundView.setupChatBootStyleEnglish()
            animationView.setupChatBootStyleEnglish()
        }
        
        animationView.play(fromProgress: 0,
                           toProgress: 2,
                           loopMode: LottieLoopMode.playOnce,
                           completion: { (finished) in
            if finished {
                self.animationView.isHidden = true
                self.backGroundView.isHidden = false
            } else {
                print("Animation cancelled")
            }
        })
    }
    
    func setupAnimationView() {
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1
        animationView.play(fromProgress: 0,
                           toProgress: 2,
                           loopMode: LottieLoopMode.playOnce,
                           completion: { (finished) in
            if finished {
                self.animationView.isHidden = true
                self.backGroundView.isHidden = false
            } else {
                print("Animation cancelled")
            }
        })
    }
    
    func tableViewConfigration() {
        categoryTableView.tableFooterView = nil
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.register(UINib(nibName: "ChatBootSingleCategoryCell", bundle: nil), forCellReuseIdentifier: "ChatBootSingleCategoryCell")
    }
    
    func configCell(model : [Category]) {
        categoryArray = model
        categoryTableView.reloadData()
    }
}

//MARK: - TableView Extension
extension ChatBootCategoryCell : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatBootSingleCategoryCell", for: indexPath) as! ChatBootSingleCategoryCell
        cell.configCell(title: categoryArray[indexPath.row].name ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCategory?(categoryArray[indexPath.row])
        print(categoryArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
