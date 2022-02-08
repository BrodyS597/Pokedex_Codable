//
//  ResultError.swift
//  Pokedex_Codable
//
//  Created by Brody Sears on 2/8/22.
//

import Foundation

enum ResultError: LocalizedError {
    case invalidURL(String)
    case thrownError(Error)
    case noData
    case unableToDecode
    
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Unable to reach the server. Please try again"
        case .thrownError(let error):
            return "Error: \(error.localizedDescription) -> \(error)"
        case .noData:
            return "The server responded with no data. Please try again"
        case .unableToDecode:
            return "The server responded with bad data. Please try again"
        }
    } 
}
