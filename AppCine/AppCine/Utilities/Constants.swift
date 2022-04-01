//
//  Constants.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import UIKit


enum MediaType: Int, CaseIterable {
    case movies = 0, tvShows
    
    var name: String {
        switch self {
        case .movies: return "Movies"
        case .tvShows: return "TV Shows"
        }
    }
}


enum MediaState {
    case stored(Media)
    case online(ACMedia)
}


enum ACLabel {
    static let done               = "Ok"
    static let send               = "Send"
    static let name               = "Name"
    static let gender             = "Gender"
    static let rate               = "Vote average"
    static let date               = "Release date"
    static let language           = "Original language"
    static let cancelled          = "cancelled"
    static let searchFor          = "Search"
    static let bookmarkVCTitle    = "Saved"
    static let searchVCTitle      = "App Cine"
    static let somethingWentWrong = "Something wen't wrong"
}


enum ACImage {
    static let star           = UIImage(systemName: "star")!
    static let film           = UIImage(systemName: "film")!
    static let media          = UIImage(systemName: "tv")!
    static let reload         = UIImage(systemName: "goforward")!
    static let calendar       = UIImage(systemName: "calendar")!
    static let language       = UIImage(systemName: "globe.americas")!
    static let bookmark       = UIImage(systemName: "bookmark")!
    static let mediaGender    = UIImage(systemName: "books.vertical")!
    static let bookmarkFilled = UIImage(systemName: "bookmark.fill")!
}


enum ACColor {
    static let orange = UIColor(red: 255/255, green: 149/255, blue: 2/255, alpha: 1)
}


enum GenderIds: Int, CaseIterable {
    case war         = 10752
    case sciFi       = 878
    case crime       = 80
    case drama       = 18
    case music       = 10402
    case wester      = 37
    case action      = 28
    case comedy      = 35
    case horror      = 27
    case family      = 10751
    case tvMovie     = 10770
    case unknown     = 404
    case mistery     = 9648
    case romance     = 10749
    case fantasy     = 14
    case history     = 36
    case thriller    = 53
    case adventure   = 12
    case animation   = 16
    case documentary = 99
}

extension GenderIds {
    var name: String {
        switch self {
        case .war:         return "War"
        case .sciFi:       return "Science Fiction"
        case .crime:       return "Crime"
        case .drama:       return "Drama"
        case .music:       return "Music"
        case .wester:      return "Wester"
        case .action:      return "Action"
        case .comedy:      return "Comedy"
        case .horror:      return "Horror"
        case .family:      return "Family"
        case .tvMovie:     return "TV Movie"
        case .unknown:     return "Unkown"
        case .mistery:     return "Mistery"
        case .romance:     return "Romance"
        case .fantasy:     return "Fantasy"
        case .history:     return "History"
        case .thriller:    return "Thriller"
        case .adventure:   return "Adventure"
        case .animation:   return "Animation"
        case .documentary: return "Documentary"
        }
    }

    init?(name: String) {
        switch name {
        case "War":             self = .war
        case "Science Fiction": self = .sciFi
        case "Crime":           self = .crime
        case "Drama":           self = .drama
        case "Music":           self = .music
        case "Wester":          self = .wester
        case "Action":          self = .action
        case "Comedy":          self = .comedy
        case "Horror":          self = .horror
        case "Family":          self = .family
        case "TV Movie":        self = .tvMovie
        case "Mistery":         self = .mistery
        case "Romance":         self = .romance
        case "Fantasy":         self = .fantasy
        case "History":         self = .history
        case "Thriller":        self = .thriller
        case "Adventure":       self = .adventure
        case "Animation":       self = .animation
        case "Documentary":     self = .documentary
        default:                self = .unknown
        }
    }
}
