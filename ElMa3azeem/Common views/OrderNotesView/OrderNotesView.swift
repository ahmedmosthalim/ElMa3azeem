//
//  OrderNotesView.swift
//  ElMa3azeem
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 06/11/2022.
//

import UIKit

class OrderNotesView: UIView {
    let XIB_NAME = "OrderNotesView"

    // MARK: - outlets -

    @IBOutlet weak var notesTv: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!

    private var images: [Image]?
    private var note: String?
    var imageTapped: ((String) -> Void)?

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    deinit {
        print("\(NSStringFromClass(self.classForCoder).components(separatedBy: ".").last ?? "XIB") is deinit, No memory leak found")
    }

    // MARK: - Design -

    private func commonInit() {
        guard let xib = Bundle.main.loadNibNamed(XIB_NAME, owner: self, options: nil)?.first, let viewFromXib = xib as? UIView else { return }
        viewFromXib.frame = bounds
        addSubview(viewFromXib)

        collectionViewConfigration()
    }

    private func collectionViewConfigration() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.register(UINib(nibName: "ComplaintDetailsCell", bundle: nil), forCellWithReuseIdentifier: "ComplaintDetailsCell")
    }

    private func isHaveDetailsImage() {
        imagesCollectionView.isHidden = images?.isEmpty ?? false
    }

    private func handleVisibility() {
        isHidden = note?.isEmpty ?? false
    }

    func configView(notes: String?, noteIamges: [Image]?) {
        images = noteIamges ?? []
        note = notes ?? ""
        notesTv.text = notes

        imagesCollectionView.reloadData()
        isHaveDetailsImage()
        handleVisibility()
    }
}

// MARK: - CollectionView Extension

extension OrderNotesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComplaintDetailsCell", for: indexPath) as! ComplaintDetailsCell

        cell.configerCellWithUrl(image: images?[indexPath.row].url ?? "")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imageTapped?(images?[indexPath.row].url ?? "")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
}
