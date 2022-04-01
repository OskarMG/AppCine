//
//  OverviewLabel.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 31/3/22.
//

import UIKit

class OverviewLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        tintColor     = .secondaryLabel
        numberOfLines = 4
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 14, weight: .regular)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
