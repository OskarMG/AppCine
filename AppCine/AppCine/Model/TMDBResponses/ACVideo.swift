//
//  ACVideo.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 2/4/22.
//

import Foundation


struct ACVideo: Codable {
    
    let id: String
    let name: String?
    let key:  String?
    let site: String?
    let size: Int?
    let type: String?
    let isOfficial: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case key
        case site
        case size
        case type
        case isOfficial = "official"
    }
}
