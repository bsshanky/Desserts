//
//  DessertListService.swift
//  Desserts
//
//  Created by Shashank  on 6/18/24.
//

import Foundation

protocol DessertListProtocol {
    
    func fetchDesserts() async throws -> [Dessert]
}

class DessertListService: DessertListProtocol {
    
    private let baseURL = APIEndpoints.dessertsList
    
    func fetchDesserts() async throws -> [Dessert] {
        guard let url = URL(string: baseURL) else {
            throw APIError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check for HTTP response errors
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        // Decode the JSON data into the desired model
        let responseModel = try JSONDecoder().decode(DessertListResponse.self, from: data)
        return responseModel.desserts
    }
}

class MockDessertListService: DessertListProtocol {
    
    var shouldReturnError = false
    var mockDesserts: [Dessert] = []
    var error: Error = APIError.unknown
    
    func fetchDesserts() async throws -> [Dessert] {
        if shouldReturnError {
            throw error
        }
        return mockDesserts
    }
}



