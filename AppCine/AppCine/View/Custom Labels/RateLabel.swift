//
//  RateLabel.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 31/3/22.
//

import UIKit

class RateLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        numberOfLines      = 1
        textColor          = .white
        textAlignment      = .center
        clipsToBounds      = true
        layer.cornerRadius = 5
        backgroundColor    = ACColor.orange
        font = .systemFont(ofSize: 12, weight: .bold)
        translatesAutoresizingMaskIntoConstraints = false
    }

}
