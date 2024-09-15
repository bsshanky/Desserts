//
//  DessertDetailService.swift
//  Desserts
//
//  Created by Shashank  on 6/19/24.
//

import Foundation

protocol DessertDetailProtocol: Sendable {
    
    func fetchDessertDetail(by id: String) async throws -> DessertDetail
}

final class DessertDetailService: DessertDetailProtocol {
    
    func fetchDessertDetail(by id: String) async throws -> DessertDetail {
        let urlString = APIEndpoints.dessertDetail + "\(id)"
        guard let url = URL(string: urlString) else {
            throw APIError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check for HTTP response errors
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        // Decode the JSON data into the desired model
        let responseModel = try JSONDecoder().decode([String: [DessertDetail]].self, from: data)
        
        // Extract the first item from the response
        guard let dessertDetail = responseModel["meals"]?.first else {
            throw APIError.unknown
        }
        
        return dessertDetail
    }
}

// For Unit testing
class MockDessertDetailService: DessertDetailProtocol {
    
    var shouldReturnError = false
    var mockDessertDetail: DessertDetail?
    var error: Error = APIError.unknown
    
    func fetchDessertDetail(by id: String) async throws -> DessertDetail {
        if shouldReturnError {
            throw error
        } else if let mockDessertDetail = mockDessertDetail {
            return mockDessertDetail
        } else {
            throw APIError.unknown
        }
    }
}
