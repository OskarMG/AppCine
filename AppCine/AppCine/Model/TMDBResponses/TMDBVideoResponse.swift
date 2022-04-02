//
//  TMDBVideoResponse.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 2/4/22.
//

import Foundation


struct TMDBVideoResponse: Codable {
    
    let id: Int
    let results: [ACVideo]
    
}
