//
//  ACMediaCollectionView.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 28/3/22.
//


import UIKit

protocol FavoriteButtonProtocol: AnyObject {
    func onBookmarkTap(media: ACMedia, completion: @escaping(Bool)->Void)
}

class ACMediaCollectionView: UICollectionViewCell {
    
    //MARK: - Propeties
    static let reuseId = "ACMediaCollectionView"
    
    let container    = UIView()
    let titleLabel   = UILabel()
    let rateLabel    = RateLabel()
    let bookmarkFlag = BookmarkFlagButton(frame: .zero)
    let mediaImageView = UIImageView(image: ACImage.film)
    
    var media: ACMedia!
    weak var delegate: FavoriteButtonProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Private methods
    private func setupUI() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        
        mediaImageView.frame = bounds
        mediaImageView.contentMode = .scaleAspectFill
        
        contentView.addSubviews(mediaImageView, container, rateLabel, bookmarkFlag)
        
        bookmarkFlag.addTarget(self, action: #selector(onBookmarkTap), for: .touchUpInside)
        
        container.frame = bounds
        container.createGradientLayer()
        container.backgroundColor = .clear
        container.isUserInteractionEnabled = false
        container.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            bookmarkFlag.widthAnchor.constraint(equalToConstant:  25),
            bookmarkFlag.heightAnchor.constraint(equalToConstant: 24),
            bookmarkFlag.bottomAnchor.constraint(equalTo:   contentView.bottomAnchor,   constant: -UIHelper.padding10),
            bookmarkFlag.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIHelper.padding10),
            
            container.topAnchor.constraint(equalTo:      contentView.topAnchor),
            container.heightAnchor.constraint(equalTo:   contentView.heightAnchor),
            container.leadingAnchor.constraint(equalTo:  contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: bookmarkFlag.leadingAnchor, constant: -UIHelper.padding5),
            
            rateLabel.topAnchor.constraint(equalTo:      contentView.topAnchor,      constant: UIHelper.padding10),
            rateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIHelper.padding10),
            rateLabel.widthAnchor.constraint(equalToConstant: 28),
            rateLabel.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.centerYAnchor.constraint(equalTo:  bookmarkFlag.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            titleLabel.leadingAnchor.constraint(equalTo:  container.leadingAnchor, constant: UIHelper.padding10)
        ])
    }
    
    private func updateBookmarkFlag(_ flag: Bool) {
        let image = flag ? ACImage.bookmarkFilled : ACImage.bookmark
        self.bookmarkFlag.setBackgroundImage(image, for: .normal)
    }

    
    func setData(with media: ACMedia) {
        self.media = media
        DispatchQueue.main.async {
            self.titleLabel.text = media.title ?? media.name
            self.rateLabel.text  = media.voteAverage == 0.0 ? "0" : "\(media.voteAverage)"
            self.updateBookmarkFlag(media.isLocal)
        }
        
        if let path = media.posterPath {
            TMDBClient.shared.downloadPosterImage(path: path) {[weak self] image in
                guard let self = self else { return }
                self.mediaImageView.image = image ?? ACImage.film
            }
        }
    }
    
    
    @objc private func onBookmarkTap() {
        delegate?.onBookmarkTap(media: media) { _ in 
            DispatchQueue.main.async { self.updateBookmarkFlag(self.media.isLocal) }
        }
    }
    
}

