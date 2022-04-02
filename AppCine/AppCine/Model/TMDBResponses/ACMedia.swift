//
//  ACMedia.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import CoreData
import Foundation

protocol ACMediaProtocol {
    func getMedia() -> ACMedia
}

struct ACMedia: Codable, Equatable {
    
    let id: Int
    let name: String?
    let title: String?
    let overview: String?
    var genreIds: [Int]?
    let posterPath: String?
    let voteAverage: Double
    let releaseDate: String?
    let originalLanguage: String?
    
    var type: MediaType!
    var posterData: Data!
    
    init(id: Int, media: Media) {
        self.id          = id
        self.name        = media.name
        self.type        = media.type == MediaType.movies.name ? .movies : .series
        self.title       = media.title
        self.overview    = media.overview
        self.genreIds    = []
        self.posterPath  = nil
        self.posterData  = media.poster
        self.voteAverage = media.voteAverage
        self.releaseDate = media.releaseDate
        self.originalLanguage = media.originalLanguage
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case overview
        case genreIds    = "genre_ids"
        case posterPath  = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
    }
}


extension ACMedia {
    
    var isLocal: Bool {
        if let _ = PersistentManager.shared.getMediaBy(id: "\(id)") { return true }
        return false
    }
    
    var getGenderTags: String? {
        var tags = [String]()
        guard let ids = genreIds else { return nil }
        for id in ids { if let tag = GenderIds.init(rawValue: id) { tags.append(tag.name) } }
        return tags.joined(separator: ", ")
    }
    
    mutating func setIdsFromTags(_ tags: String?) {
        var tagsId = [Int]()
        guard let tags = tags else { return }
        let list = tags.split(separator: ",")
        for tag in list { if let ele = GenderIds.init(name: String(tag)) { tagsId.append(ele.rawValue) } }
        genreIds = tagsId
    }
    
}
