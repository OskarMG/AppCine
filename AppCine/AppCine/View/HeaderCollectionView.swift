//
//  HeaderCollectionView.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import UIKit

class HeaderCollectionView: UICollectionReusableView {
    
    //MARK: - Properties
    static let reuseId = "HeaderCollectionView"
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    //MARK: - Private Methods
    private func configure() {
        addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalTo:   heightAnchor),
            titleLabel.leadingAnchor.constraint(equalTo:  leadingAnchor,  constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}
