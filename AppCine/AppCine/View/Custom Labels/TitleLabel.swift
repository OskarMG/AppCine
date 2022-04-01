//
//  TitleLabel.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 31/3/22.
//

import UIKit

class TitleLabel: UILabel {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        tintColor     = .label
        numberOfLines = 2
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
