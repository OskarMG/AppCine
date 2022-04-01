//
//  AppCineMainTabbar.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import UIKit

class AppCineMainTabbar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [createSearchNC(), createFavoritesNC()]
        configureVC()
    }    

    private func configureVC() {
        view.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .systemRed
    }
    
    // MARK: - Navigation
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = ACLabel.searchVCTitle
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    func createFavoritesNC() -> UINavigationController {
        let favoritesVC = BookmarkVC()
        favoritesVC.title = ACLabel.bookmarkVCTitle
        
        let item = UITabBarItem(title: ACLabel.bookmarkVCTitle, image: ACImage.bookmark, tag: 1)
        item.selectedImage = ACImage.bookmarkFilled
        
        favoritesVC.tabBarItem = item
        return UINavigationController(rootViewController: favoritesVC)
    }
    
}
