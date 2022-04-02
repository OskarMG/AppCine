//
//  MediaDetailRowView.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 31/3/22.
//

import UIKit


class MediaDetailRowView: UIView {
    
    //MARK: - UI Elements
    private let icon  = UIImageView(image: ACImage.film)
    private let label = TitleLabel(frame: .zero)
    let valueLabel    = TitleLabel(frame: .zero)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(icon: UIImage, label: String) {
        self.init(frame: .zero)
        
        self.icon.image = icon
        self.label.text = label
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        icon.tintColor   = ACColor.orange
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textAlignment = .right
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        valueLabel.numberOfLines = 2
        
        let separator = UIView()
        separator.backgroundColor = .secondarySystemFill
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(icon, label, valueLabel, separator)
            
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIHelper.padding10),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30),
            
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: UIHelper.padding10),
            
            valueLabel.centerYAnchor.constraint(equalTo:  centerYAnchor),
            valueLabel.widthAnchor.constraint(equalTo:    widthAnchor, multiplier: 0.62),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIHelper.padding10),
            
            separator.bottomAnchor.constraint(equalTo:   bottomAnchor,   constant: UIHelper.padding5),
            separator.leadingAnchor.constraint(equalTo:  leadingAnchor,  constant: UIHelper.padding10),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIHelper.padding10),
            separator.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
}
