//
//  BookmarkTableViewCell.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 31/3/22.
//

import UIKit

protocol BookmarkFlagProtocol: AnyObject {
    func onBookmarkFlagTap(_ media: Media)
}

class BookmarkTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    static let reuseId = "BookmarkTableViewCell"
    
    var container:     UIView!
    var poster:        UIImageView!
    var rateLabel:     RateLabel!
    var titleLabel:    TitleLabel!
    var genderLabel:   TitleLabel!
    var bookmarkFlag:  BookmarkFlagButton!
    var overviewLabel: OverviewLabel!
    
    var media: Media!
    weak var delegate: BookmarkFlagProtocol!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Private methods
    private func setupUI() {
        if container == nil {
            container = UIView()
            container.clipsToBounds      = true
            container.backgroundColor    = .secondarySystemBackground
            container.layer.cornerRadius = 10
            container.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(container)
            
            let shadowView = UIView()
            shadowView.backgroundColor = .clear
            shadowView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(shadowView)
            shadowView.bringToFront()
            
            poster = UIImageView(image: ACImage.film)
            poster.clipsToBounds = true
            poster.contentMode = .scaleAspectFill
            poster.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(poster)
            
            rateLabel = RateLabel()
            container.addSubview(rateLabel)
            
            bookmarkFlag = BookmarkFlagButton(frame: .zero)
            bookmarkFlag.addTarget(self, action: #selector(onBookmarkTap), for: .touchUpInside)
            container.addSubview(bookmarkFlag)
            
            titleLabel = TitleLabel(frame: .zero)
            container.addSubview(titleLabel)
            
            genderLabel = TitleLabel(frame: .zero)
            genderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            genderLabel.textColor = .secondaryLabel
            container.addSubview(genderLabel)
            
            overviewLabel = OverviewLabel(frame: .zero)
            container.addSubview(overviewLabel)
            
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo:      contentView.topAnchor),
                container.bottomAnchor.constraint(equalTo:   contentView.bottomAnchor,   constant: -UIHelper.padding10 * 2),
                container.leadingAnchor.constraint(equalTo:  contentView.leadingAnchor,  constant: UIHelper.padding10  * 1.5),
                container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIHelper.padding10 * 1.5),
                
                shadowView.topAnchor.constraint(equalTo:     container.topAnchor),
                shadowView.heightAnchor.constraint(equalTo:  container.heightAnchor),
                shadowView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                shadowView.widthAnchor.constraint(equalToConstant: 150),
                
                poster.topAnchor.constraint(equalTo:     container.topAnchor),
                poster.heightAnchor.constraint(equalTo:  container.heightAnchor),
                poster.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                poster.widthAnchor.constraint(equalToConstant: 150),
                
                rateLabel.topAnchor.constraint(equalTo:      container.topAnchor,      constant: UIHelper.padding10),
                rateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -UIHelper.padding10),
                rateLabel.widthAnchor.constraint(equalToConstant: 28),
                rateLabel.heightAnchor.constraint(equalToConstant: 30),
                
                titleLabel.topAnchor.constraint(equalTo:      rateLabel.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo:  poster.trailingAnchor,   constant: UIHelper.padding10),
                titleLabel.trailingAnchor.constraint(equalTo: rateLabel.leadingAnchor, constant: -UIHelper.padding10),
                
                genderLabel.topAnchor.constraint(equalTo:      titleLabel.bottomAnchor, constant: UIHelper.padding5),
                genderLabel.leadingAnchor.constraint(equalTo:  poster.trailingAnchor,   constant: UIHelper.padding10),
                genderLabel.trailingAnchor.constraint(equalTo: rateLabel.leadingAnchor, constant: -UIHelper.padding10),
                
                
                overviewLabel.topAnchor.constraint(equalTo:      genderLabel.bottomAnchor, constant:  UIHelper.padding10),
                overviewLabel.leadingAnchor.constraint(equalTo:  poster.trailingAnchor,    constant:  UIHelper.padding10),
                overviewLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -UIHelper.padding10),
                
                bookmarkFlag.widthAnchor.constraint(equalToConstant:  25),
                bookmarkFlag.heightAnchor.constraint(equalToConstant: 24),
                bookmarkFlag.bottomAnchor.constraint(equalTo:   container.bottomAnchor,   constant: -UIHelper.padding10),
                bookmarkFlag.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -UIHelper.padding10),
            ])
            
            DispatchQueue.main.async { shadowView.createGradientLayer() }
        }
    }
    
    private func updateBookmarkFlag(_ flag: Bool) {
        let image = flag ? ACImage.bookmarkFilled : ACImage.bookmark
        bookmarkFlag.setBackgroundImage(image, for: .normal)
    }
    
    
    func setData(with media: Media) {
        self.media = media
        DispatchQueue.main.async {
            self.rateLabel.text = "\(media.voteAverage)"
            self.titleLabel.text = media.name ?? media.title
            self.genderLabel.text = media.genderTags
            self.overviewLabel.text = media.overview
            self.updateBookmarkFlag(true)
            if let imgData = media.poster { self.poster.image = UIImage(data: imgData) }
        }
    }
    
    
    //MARK: - Events
    @objc private func onBookmarkTap() { delegate?.onBookmarkFlagTap(media) }
    
}
