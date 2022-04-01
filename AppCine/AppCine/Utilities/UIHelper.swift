//
//  UIHelper.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import UIKit


enum UIHelper {
    
    static var padding5:  CGFloat { return CGFloat(5) }
    static var padding10: CGFloat { return CGFloat(10) }
    
    static func createMediaSection(inSection: Int, isEmpty: Bool = false) -> NSCollectionLayoutSection {
        let height: CGFloat = isEmpty ? 0 : 200
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(height)),
            subitems: [createItemForMediaSectionComponentLayoutGroup()]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading  = UIHelper.padding10 * 2
        section.contentInsets.trailing = UIHelper.padding10 * 3
        section.orthogonalScrollingBehavior = .groupPaging
        
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
                  elementKind: MediaType.init(rawValue: inSection)!.name, alignment: .topLeading)
        ]
        
        return section
    }
    
    private static func createItemForMediaSectionComponentLayoutGroup() -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        item.contentInsets.trailing = UIHelper.padding10 * 2
        return item
    }
}
