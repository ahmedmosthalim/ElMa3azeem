//
//  extensionUICollectionView.swift
//  Masar Ebdaa
//
//  Created by Abdullah Tarek & Ahmed Mostafa Halim on 19/11/2022.
//

 
import UIKit

extension UICollectionView {
    func createLeftAlignedLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(          // this is your cell
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(50),         // variable width
                heightDimension: .absolute(50)          // fixed height
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),  // 100% width as inset by its Section
                heightDimension: .estimated(50)         // variable height; allows for multiple rows of items
            ),
            subitems: [item]
        )
        group.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)
        group.interItemSpacing = .fixed(10)         // horizontal spacing between cells
        
        return UICollectionViewCompositionalLayout(section: .init(group: group))
    }
}
