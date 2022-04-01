//
//  Endpoints.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 1/4/22.
//

import Foundation


enum Endpoints {
    static let apiKey = "{API_KEY}"
    static let base = "https://api.themoviedb.org/3"
    static let apiKeyParam = "?api_key=\(apiKey)"
    
    case searchByMovie(String)
    case searchByTvShow(String)
    
    case popularMovies
    case popularTvShows
    case posterImageUrl(String)
    
    private var strValue: String {
        switch self {
        case .searchByMovie(let query): return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        case .searchByTvShow(let query): return Endpoints.base + "/search/tv" + Endpoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        case .popularMovies:  return Endpoints.base + "/movie/popular" + Endpoints.apiKeyParam
        case .popularTvShows: return Endpoints.base + "/tv/popular" + Endpoints.apiKeyParam
        case .posterImageUrl(let path): return "https://image.tmdb.org/t/p/w500" + path
        }
    }
    
    var url: URL { return URL(string: strValue)! }
}
