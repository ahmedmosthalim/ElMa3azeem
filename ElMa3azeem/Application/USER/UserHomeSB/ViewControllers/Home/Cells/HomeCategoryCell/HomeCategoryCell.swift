//
//  HomeCategoryCell.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 28/11/2022.
//

import UIKit

protocol selectCategoryProtocol: AnyObject {
    func selectStoreFromHome(index: Int)
    func selectCategoryCell(index: Int)
}

class HomeCategoryCell: UITableViewCell, HomeCategotyCellView {
    @IBOutlet weak var CategoryCollectionView: CustomCollectionView!
    @IBOutlet weak var collectionHight: NSLayoutConstraint!

    var size = 0
    var type = ""
    var numberOfItem = 0
    var categoty = [Category]()
    var count = 0

    let screenSize: CGRect = UIScreen.main.bounds
    var collectionViewSize: Double?

    weak var delegate: selectCategoryProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupView() {
        CategoryCollectionView.delegate = self
        CategoryCollectionView.dataSource = self
        CategoryCollectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
    }

    func categoryCellView(cell: CategoryCellView, forRow row: Int) {
        cell.setTitle(name: categoty[row].name ?? "")
        cell.setImage(url: categoty[row].image ?? "")
    }

    func configureCategoryCell(model: [Category], size: String, type: String, rows: String) {
        self.type = type
        categoty = model
        self.size = Int(size) ?? 0
        numberOfItem = Int(rows) ?? 0
        CategoryCollectionView.reloadData()

        if (count % 2) == 0 {
            collectionHight.constant = (screenSize.width / 2) * ceil(CGFloat(count / 2) + 1)
        } else {
            collectionHight.constant = (screenSize.width / 2) * ceil(CGFloat(count / 2) + 1)
        }
    }
}

extension HomeCategoryCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoty.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell

        categoryCellView(cell: cell, forRow: indexPath.row)

        cell.selectCategory = {
            self.delegate?.selectCategoryCell(index: indexPath.row)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 8
        let collectionViewSize = (collectionView.frame.width - padding) / 2
        if indexPath.row == 0
        {
            return CGSize(width: collectionViewSize*2, height: collectionViewSize)
        }else
        {
            return CGSize(width: collectionViewSize, height: collectionViewSize)
        }
    }
}

class CustomCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, intrinsicContentSize) {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return collectionViewLayout.collectionViewContentSize
    }
}
