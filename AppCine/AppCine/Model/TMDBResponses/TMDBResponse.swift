//
//  TMDBResponse.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import Foundation

protocol TMDBMediaType {
    associatedtype ResultType
    var results: [ResultType] { get }
}

struct TMDBResponse<ResponseType: Codable>: TMDBMediaType, Codable {
    typealias ResultType = ResponseType
    
    let page:         Int
    var results:      [ResponseType]
    let totalPages:   Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages   = "total_pages"
        case totalResults = "total_results"
    }
}
