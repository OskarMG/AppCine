//
//  ACError.swift
//  AppCine
//
//  Created by Oscar Martínez Germán on 27/3/22.
//

import Foundation


enum ACError: String, Error {
    
    case invalidData     = "Data received from the server was invalid. Please try again."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidadUrl    = "Invalid URL, contact development team."
    
}
