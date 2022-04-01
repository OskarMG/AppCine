//
//  ACSearch.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import UIKit
import CoreData

class ACSearch: UIViewController, UISearchResultsUpdating, KeyboardToolbarDelegate {

    //MARK: - Properties
    var searchController: UISearchController!
    
    override open var shouldAutorotate: Bool { return false }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureSearchController()
    }
    
    
    func configureVC() {
        navigationController?.navigationBar.tintColor = .systemRed
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func configureSearchController() {
        searchController = UISearchController()
        setPlaceHolder()
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .systemRed
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.addKeyboardToolBar(leftButtons: [], rightButtons: [.done], toolBarDelegate: self)
        navigationItem.searchController = searchController
    }
    
    
    func keyboardToolbar(button: UIBarButtonItem, type: KeyboardToolbarButton, isInputAccessoryViewOf textField: UITextField) {
        switch type {
            case .done: self.dismissKeyBoard()
            case .send: break
        }
    }
    
    private func dismissKeyBoard() {
        DispatchQueue.main.async { self.searchController.searchBar.searchTextField.endEditing(true) }
    }
    
    
    //MARK: - Configure Methods
    func setPlaceHolder(_ placeHolder: String = ACLabel.searchFor) {
        searchController.searchBar.placeholder = placeHolder
    }
    
    
    //MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) { }
    
    
}
