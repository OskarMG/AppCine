//
//  TMDBError.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import Foundation


struct TMDBError: Decodable, Error {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}


extension TMDBError: LocalizedError {
    
    var errorDescription: String? {
        return statusMessage
    }
    
}
