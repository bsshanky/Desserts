//
//  ErrorService.swift
//  Desserts
//
//  Created by Shashank  on 6/19/24.
//

import Foundation

// Custom API error to handle different error cases
enum APIError: Error, CustomStringConvertible {
    case badURL
    case badResponse(statusCode: Int)
    case parsing(DecodingError?)
    case unknown
    case noInternetConnection
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "Unexpected error occurred."
        case .badURL:
            return "Cannot reach server."
        case .parsing(_):
            return "Unable to fetch data."
        case .badResponse(let statusCode):
            return "Bad response \(statusCode)"
        case .noInternetConnection:
            return "No internet connection."
        }
    }
    
    var description: String {
        switch self {
        case .unknown: return "unknown error"
        case .badURL: return "invalid URL"
        case .parsing(let error):
            return "parsing error: \(error?.localizedDescription ?? "")"
        case .badResponse(let statusCode):
            return "bad response; status code \(statusCode)"
        case .noInternetConnection:
            return "no internet connection"
        }
    }
}

/*
 
 By conforming to CustomStringConvertible, you can control how instances of your types are represented as strings, making debugging and logging more informative and easier to read.
 
 */
