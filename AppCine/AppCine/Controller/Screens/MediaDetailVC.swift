//
//  MediaDetailVC.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 31/3/22.
//

import UIKit
import youtube_ios_player_helper

class MediaDetailVC: UIViewController {
    
    //MARK: - Properties
    private var mediaId: String!
    private let mediaState: MediaState
    private var convenienceMedia: ACMedia!
    
    private var isLocal: Bool? {
        if let id = mediaId {
            if let _ = PersistentManager.shared.getMediaBy(id: "\(id)") { return true }
            return false
        }
        return nil
    }
    
    
    //MARK: - UI Elements
    private let topContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let poster: UIImageView = {
        let imageView = UIImageView(image: ACImage.film)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var bookmarkFlag: UIBarButtonItem!
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.bounces = true
        scrollView.backgroundColor  = .clear
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: .zero, left: .zero, bottom: 60, right: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let overviewLabel: OverviewLabel = {
        let label = OverviewLabel(frame: .zero)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let titleRowView = MediaDetailRowView(icon: ACImage.media,       label: ACLabel.name)
    private let genderView   = MediaDetailRowView(icon: ACImage.mediaGender, label: ACLabel.gender)
    private let rateRowView  = MediaDetailRowView(icon: ACImage.star,        label: ACLabel.rate)
    private let dateRowView  = MediaDetailRowView(icon: ACImage.calendar,    label: ACLabel.date)
    private let langRowView  = MediaDetailRowView(icon: ACImage.language,    label: ACLabel.language)
    
    private var stackView:  UIStackView!
    private var playerView: YTPlayerView!
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        setupUI()
        unwrapMedia()
        getVideos()
    }
    
    
    //MARK: - Init Methods
    init(mediaState: MediaState) {
        self.mediaState = mediaState
        super.init(nibName: nil, bundle: nil)
        self.setConvenienceMedia()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - Private Methods
    private func configureVC() {
        bookmarkFlag = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(onBookmarkTap))
        navigationItem.rightBarButtonItems = [bookmarkFlag]
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        topContainer.addSubview(poster)
        
        if case .stored(_) = mediaState { updateBookmarkFlag(true) } else {
            if case let .online(media) = mediaState { updateBookmarkFlag(media.isLocal) }
        }
        
        stackView = UIStackView(arrangedSubviews: [overviewLabel, titleRowView, genderView, rateRowView, dateRowView, langRowView])
        stackView.axis = .vertical
        stackView.spacing = UIHelper.padding10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubviews(topContainer, scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(overviewLabel, stackView)
        
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo:      view.safeAreaLayoutGuide.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo:  view.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topContainer.heightAnchor.constraint(equalToConstant: 200),
            
            poster.topAnchor.constraint(equalTo:      topContainer.topAnchor),
            poster.leadingAnchor.constraint(equalTo:  topContainer.leadingAnchor),
            poster.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
            poster.heightAnchor.constraint(equalTo:   topContainer.heightAnchor),
            
            scrollView.topAnchor.constraint(equalTo:      topContainer.bottomAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo:  view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo:   view.safeAreaLayoutGuide.bottomAnchor),
            
            overviewLabel.topAnchor.constraint(equalTo:      contentView.topAnchor,      constant: UIHelper.padding10),
            overviewLabel.leadingAnchor.constraint(equalTo:  contentView.leadingAnchor,  constant: UIHelper.padding10 * 2),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIHelper.padding10 * 2),
            
            stackView.topAnchor.constraint(equalTo:      overviewLabel.bottomAnchor, constant: UIHelper.padding10 * 2),
            stackView.leadingAnchor.constraint(equalTo:  contentView.leadingAnchor,  constant: UIHelper.padding10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIHelper.padding10),
            stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 250)
        ])
    }
    
    private func updateBookmarkFlag(_ flag: Bool) {
        DispatchQueue.main.async {
            self.bookmarkFlag.image = flag ? ACImage.bookmarkFilled : ACImage.bookmark
        }
    }
    
    private func updateContentSize() {
        let topContHeight   = topContainer.bounds.size.height
        let overviewHeight  = overviewLabel.bounds.size.height
        let stackViewHeight = stackView.bounds.size.height
        
        let height: CGFloat = topContHeight + overviewHeight + stackViewHeight + (UIHelper.padding10 * 5)
        let contentSize = CGSize(width: scrollView.frame.size.width, height: height)
        scrollView.contentSize = contentSize
        contentView.frame.size = contentSize
    }
    
    private func formatDate(str: String?) -> String? {
        let date = str?.split(separator: "-")
        if let date = date, date.count == 3 { return "\(date[2])/\(date[1])/\(date[0])" }
        return str
    }
    
    private func setConvenienceMedia() {
        switch mediaState {
        case .stored(let media):
            mediaId = media.id
            if let id = Int(mediaId) {
                convenienceMedia = ACMedia(id: id, media: media)
                convenienceMedia.setIdsFromTags(media.genderTags)
            }
        case .online(let aCMedia): mediaId = String(aCMedia.id)
        }
    }
    
    private func setData(title: String?, poster: UIImage?, genders: String?, overview: String?, rate: Double?, releaseDate: String?, language: String?) {
        DispatchQueue.main.async {
            var tags: String!
            if let genders = genders { if genders.isEmpty { tags = "🤷🏽‍♂️"} else { tags = genders} }
            
            self.topContainer.addBlurBG(effect: .prominent, with: poster)
            self.poster.bringToFront()
            
            self.poster.image                 = poster
            self.overviewLabel.text           = overview
            self.titleRowView.valueLabel.text = title ?? "🤷🏽‍♂️"
            self.genderView.valueLabel.text   = tags ?? "🤷🏽‍♂️"
            self.rateRowView.valueLabel.text  = String(rate ?? 0)
            self.dateRowView.valueLabel.text  = self.formatDate(str: releaseDate) ?? "🤷🏽‍♂️"
            self.langRowView.valueLabel.text  = language?.uppercased() ?? "🤷🏽‍♂️"
            self.updateContentSize()
        }
    }
    
    private func unwrapMedia() {
        if case let .stored(media) = mediaState {
            setData(
                title:       media.name ?? media.title,
                poster:      UIImage(data: media.poster ?? Data()),
                genders:     media.genderTags,
                overview:    media.overview,
                rate:        media.voteAverage,
                releaseDate: media.releaseDate,
                language:    media.originalLanguage
            )
            return
        }
        
        if case let .online(media) = mediaState {
            TMDBClient.shared.downloadPosterImage(path: media.posterPath ?? "") {[weak self] image in
                guard let self = self else { return }
                self.setData(
                    title:       media.name ?? media.title,
                    poster:      image,
                    genders:     media.getGenderTags,
                    overview:    media.overview,
                    rate:        media.voteAverage,
                    releaseDate: media.releaseDate,
                    language:    media.originalLanguage
                )
            }
        }
    }
    
    
    private func getVideoHandleResponse(videos: [ACVideo]?) {
        dismissLoadingView()
        if let videos = videos {
            for video in videos {
                if let key = video.key, video.isOfficial {
                    addPlayer(with: key)
                    break
                }
            }
        }
    }
    
    
    //MARK: - Network calls
    private func getVideos() {
        showLoading(in: topContainer, backgroundAlpha: 0)
        switch mediaState {
        case .stored(_): TMDBClient.shared.getVideos(for: convenienceMedia.type,  with: mediaId, completion: getVideoHandleResponse)
        case .online(let aCMedia): TMDBClient.shared.getVideos(for: aCMedia.type, with: mediaId, completion: getVideoHandleResponse)
        }
    }
    
    
    //MARK: - CoreData Methods
    private func existingMedia(_ id: String) -> Bool {
        if let _ = PersistentManager.shared.getMediaBy(id: "\(id)") { return true }
        return false
    }
    
    
    //MARK: - Event Methods
    func handleContextResponse(successful: Bool) {
        guard successful else { return }
        updateBookmarkFlag(existingMedia(mediaId))
    }
    
    @objc func onBookmarkTap() {
        if existingMedia(mediaId) { PersistentManager.shared.deleteMedia(mediaId, successful: handleContextResponse) }
        else {
            switch mediaState {
            case .stored(_):
                if let toSave = convenienceMedia { PersistentManager.shared.addToBookmark(toSave, successful: handleContextResponse) }
            case .online(let aCMedia): PersistentManager.shared.addToBookmark(aCMedia, successful: handleContextResponse)
            }
        }
    }
}




//MARK: - MediaDetail Video Player Methods
extension MediaDetailVC: YTPlayerViewDelegate {
    
    func addPlayer(with key: String) {
        let width = UIScreen.main.bounds.width
        let viewFrame = CGRect(origin: .zero, size: CGSize(width: width, height: 200))
        playerView = YTPlayerView(frame: viewFrame)
        playerView.delegate = self
        DispatchQueue.main.async {
            self.topContainer.addSubview(self.playerView)
            self.playerView.load(withVideoId: key)
            self.playerView.playVideo()
            self.playerView.bringToFront()
            self.bringToFrontLoadingView()
        }
    }
    
    
}
