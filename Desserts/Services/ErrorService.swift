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
        }
    }
}
