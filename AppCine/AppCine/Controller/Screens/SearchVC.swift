//
//  SearchVC.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import UIKit
import CoreData

class SearchVC: ACSearch {

    //MARK: - Properties
    private var currentMovieTask:  URLSessionTask?
    private var currentTvShowTask: URLSessionTask?
    
    private var movies  = [ACMedia]()
    private var tvShows = [ACMedia]()
    
    
    
    //MARK: - UI Elements
    private var collectionView: UICollectionView!
    private var refreshBtn: UIBarButtonItem!
    
    //MARK: - View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureRefreshButton()
        getPopularMedia()
    }
    
    
    //MARK: - Private Methods
    private func cancelCurrentTasks() {
        currentMovieTask?.cancel()
        currentTvShowTask?.cancel()
        
        currentMovieTask = nil
        currentTvShowTask = nil
    }
    
    private func setType(_ type: MediaType, to medias: [ACMedia]) -> [ACMedia] {
        var list = [ACMedia]()
        for media in medias {
            var newMedia = media
            newMedia.type = type
            list.append(newMedia)
        }
        return list
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.dismissLoadingView()
            self.collectionView.reloadData()
            self.refreshBtn.isEnabled = true
        }
    }
    
    private func configureRefreshButton() {
        refreshBtn = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(getPopularMedia))
        navigationItem.rightBarButtonItems = [refreshBtn]
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createComponentLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: MediaType.movies.name, withReuseIdentifier:HeaderCollectionView.reuseId)
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: MediaType.tvShows.name, withReuseIdentifier: HeaderCollectionView.reuseId)
        collectionView.register(ACMediaCollectionView.self, forCellWithReuseIdentifier: ACMediaCollectionView.reuseId)
    }
    
    private func createComponentLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, _) in
            let isEmpty = section == 0 ? self.movies.isEmpty : self.tvShows.isEmpty
            return UIHelper.createMediaSection(inSection: section, isEmpty: isEmpty)
        }
    }
    
    @objc private func getPopularMedia() {
        refreshBtn.isEnabled = false
        showLoading(in: view)
        currentMovieTask  = TMDBClient.shared.getPopularsMedia(url: Endpoints.popularMovies.url , completion: searchByMovieResponseHandler)
        currentTvShowTask = TMDBClient.shared.getPopularsMedia(url: Endpoints.popularTvShows.url, completion: searchByTvShowResponseHandler)
    }
    
    
    private func goToMediaDetail(_ media: ACMedia) {
        var mediaDetailsVC: MediaDetailVC!
        
        if let storedMedia = PersistentManager.shared.getMediaBy(id: "\(media.id)") {
            mediaDetailsVC = MediaDetailVC(mediaState: MediaState.stored(storedMedia))
        } else { mediaDetailsVC = MediaDetailVC(mediaState: MediaState.online(media)) }        
        
        mediaDetailsVC.title = media.name ?? media.title
        DispatchQueue.main.async { self.navigationController?.pushViewController(mediaDetailsVC, animated: true) }
    }
    
    
    //MARK: - Search Response Handler
    func presentError(_ error: Error) {
        if let error = error as? TMDBError
        { presentAlert(title: ACLabel.somethingWentWrong, message: error.errorDescription ?? "", buttonTitle: "Ok"); return }
        if let error = error as? ACError { presentAlert(title: ACLabel.somethingWentWrong, message: error.rawValue, buttonTitle: "Ok"); return }
        presentAlert(title: ACLabel.somethingWentWrong, message: error.localizedDescription, buttonTitle: "Ok")
    }
    
    func searchByMovieResponseHandler(result: Result<[ACMedia], Error>) {
        switch result {
        case .success(let media): movies = setType(.movies, to: media).sorted { $0.voteAverage > $1.voteAverage }
        case .failure(let error): presentError(error)
        }
        reloadData()
    }
    
    func searchByTvShowResponseHandler(result: Result<[ACMedia], Error>) {
        switch result {
        case .success(let media): tvShows = setType(.tvShows, to: media).sorted { $0.voteAverage > $1.voteAverage }
        case .failure(let error): presentError(error)
        }
        reloadData()
    }
    
    
    
    //MARK: - Event Methods
    override func updateSearchResults(for searchController: UISearchController) {
        cancelCurrentTasks()
        DispatchQueue.main.async {
            if let query = searchController.searchBar.text, !query.isEmpty {
                self.showLoading(in: self.view)
                self.currentMovieTask  = TMDBClient.shared.searchBy(movie:  query, completion: self.searchByMovieResponseHandler)
                self.currentTvShowTask = TMDBClient.shared.searchBy(tvShow: query, completion: self.searchByTvShowResponseHandler)
            }
        }
    }
}



//MARK: - CollectionView Methods
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { MediaType.allCases.count }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: MediaType.init(rawValue: indexPath.section)?.name ?? "header", withReuseIdentifier: HeaderCollectionView.reuseId, for: indexPath) as! HeaderCollectionView
        header.setTitle(MediaType.init(rawValue: indexPath.section)?.name ?? "header")
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? movies.count : tvShows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ACMediaCollectionView.reuseId, for: indexPath) as! ACMediaCollectionView
        cell.delegate = self
        if indexPath.section == 0 { if !movies.isEmpty { cell.setData(with: movies[indexPath.row]) } }
        else { cell.setData(with: tvShows[indexPath.row]) }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let media = indexPath.section == 0 ? movies[indexPath.row] : tvShows[indexPath.row]
        goToMediaDetail(media)
    }
    
}


//MARK: - FavoriteButtonProtocol
extension SearchVC: FavoriteButtonProtocol {
    func onBookmarkTap(media: ACMedia, completion: @escaping (Bool) -> Void) {
        if media.isLocal { PersistentManager.shared.deleteMedia("\(media.id)", successful: completion)
        } else { PersistentManager.shared.addToBookmark(media, successful: completion) }
    }
}

