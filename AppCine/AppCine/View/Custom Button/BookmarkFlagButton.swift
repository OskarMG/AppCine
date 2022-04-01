//
//  BookmarkFlagButton.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 31/3/22.
//

import UIKit

class BookmarkFlagButton: UIButton {
    
    override var buttonType: UIButton.ButtonType {
        return .system
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        tintColor = .systemRed
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
