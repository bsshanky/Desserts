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
    private let network = Network()
    
//    init(network: Network) {
//        self.network = network
//    }
    
    func fetchDesserts() async throws -> [Dessert] {
        
        if !network.connected {
            throw APIError.noInternetConnection
        }
        
        guard let url = URL(string: baseURL) else {
            throw APIError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check for HTTP response errors
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        
        // Decode the JSON data into the desired model
//        let responseModel = try JSONDecoder().decode(DessertListResponse.self, from: data)
//        return responseModel.desserts
        
        
        do {
            // Decode the JSON data into the desired model
            let responseModel = try JSONDecoder().decode(DessertListResponse.self, from: data)
            return responseModel.desserts
        } catch let decodingError as DecodingError {
            throw APIError.parsing(decodingError)
        } catch {
            throw APIError.unknown
        }
    }
}

// For Unit testing
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

/*


 the MockDessertListService class is designed for testing purposes. In software development, particularly when writing unit tests, it is often useful to replace real responses with mock versions. This helps isolate the unit of code being tested and allows you to simulate various scenarios, including error conditions and specific data responses, without relying on external systems or networks.
 
 
 I am not handling all the errors in the resposnse.


 */


