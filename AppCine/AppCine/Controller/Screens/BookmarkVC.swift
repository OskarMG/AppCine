//
//  BookmarkVC.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 29/3/22.
//

import UIKit
import CoreData


class BookmarkVC: ACSearch {
    
    //MARK: - Properties
    private var movies  = [Media]()
    private var tvShows = [Media]()
    
    private var filteredMovies  = [Media]()
    private var filteredTvShows = [Media]()
    
    private var canAnimate = true
    private var currentMediaTypeStr: String!
    
    
    //MARK: - UI Elements
    private var tableView: UITableView!
    
    
    //MARK: - View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMedia()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    
    //MARK: - Private Methods
    private func configureTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.rowHeight      = 220
        tableView.delegate       = self
        tableView.dataSource     = self
        tableView.separatorStyle = .none
        tableView.register(BookmarkTableViewCell.self, forCellReuseIdentifier: BookmarkTableViewCell.reuseId)
        view.addSubview(tableView)
    }
    
    
    private func reloadData() { DispatchQueue.main.async { self.tableView.reloadData() } }
    
    private func fetchMedia() {
        let fetchRequest: NSFetchRequest<Media> = Media.fetchRequest()
        if let result = try? PersistentManager.shared.viewContext.fetch(fetchRequest) {
            let medias = result.sorted { $0.voteAverage > $1.voteAverage }
            movies.removeAll(); tvShows.removeAll()
            for media in medias { if media.type == MediaType.movies.name { movies.append(media) } else { tvShows.append(media) } }
            filteredMovies  = movies
            filteredTvShows = tvShows
            reloadData()
        }
    }
    
    
    private func goToMediaDetail(_ media: Media) {
        let mediaDetailsVC   = MediaDetailVC(mediaState: MediaState.stored(media))
        mediaDetailsVC.title = media.name ?? media.title
        DispatchQueue.main.async { self.navigationController?.pushViewController(mediaDetailsVC, animated: true) }
    }
    
    
    //MARK: - UISearchResultsUpdating
    func resetFilters() { fetchMedia() }
    
    override func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive else { resetFilters(); return }
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { resetFilters(); return }
        filteredMovies  = movies.filter { "\($0.name ?? "")\($0.title ?? "")".lowercased().contains(filter.lowercased()) }
        filteredTvShows = filteredTvShows.filter { "\($0.name ?? "")\($0.title ?? "")".lowercased().contains(filter.lowercased()) }
        reloadData()
    }

}





//MARK: - UITableViewDelegate & UITableViewDataSource
extension BookmarkVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { MediaType.allCases.count }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { MediaType.init(rawValue: section)?.name }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { section == 0 ? filteredMovies.count : filteredTvShows.count }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if canAnimate {
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: 0, y: 80)
            UIView.animate(
                withDuration: 0.5,
                delay: 0.025 * Double(indexPath.row),
                options: .curveEaseInOut,
                animations: {
                    cell.alpha = 1
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                }) { _ in self.canAnimate = false }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkTableViewCell.reuseId, for: indexPath) as! BookmarkTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        if indexPath.section == 0 { cell.setData(with: filteredMovies[indexPath.row]) }
        else { cell.setData(with: filteredTvShows[indexPath.row]) }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath.section == 0 ? goToMediaDetail(filteredMovies[indexPath.row]) : goToMediaDetail(filteredTvShows[indexPath.row])
    }
}



//MARK: - BookmarkFlag Delegate
extension BookmarkVC: BookmarkFlagProtocol {
    
    func getIndexPathFor(_ media: Media) -> IndexPath? {
        currentMediaTypeStr = media.type
        let medias = media.type == MediaType.movies.name ? filteredMovies : filteredTvShows
        let index = medias.firstIndex { $0.id == media.id }
        if  let row = index {
            let indexPath = IndexPath(row: row, section: media.type == MediaType.movies.name ? 0 : 1)
            return indexPath
        }
        return nil
    }
    
    func onBookmarkFlagTap(_ media: Media) {
        guard let indexPath = self.getIndexPathFor(media) else { return }
        if let id = media.id {
            PersistentManager.shared.deleteMedia(id) {[weak self] successful in
                guard let self = self else { return }
                if successful {
                    if self.currentMediaTypeStr == MediaType.movies.name {
                        self.filteredMovies.remove(at: indexPath.row)
                    } else { self.filteredTvShows.remove(at: indexPath.row) }
                    DispatchQueue.main.async { self.tableView.deleteRows(at: [indexPath], with: .fade) }
                }
            
            }
        }
    }
}

