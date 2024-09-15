//
//  DessertListViewModel.swift
//  Desserts
//
//  Created by Shashank  on 6/18/24.
//

import Foundation
import SwiftUI

@MainActor
class DessertListViewModel: ObservableObject {
    @Published var desserts: [Dessert] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let dessertListService: DessertListProtocol
    
//    init(service: DessertListProtocol = DessertListService()) {
    init(service: DessertListProtocol) {
        self.dessertListService = service
        Task {
            await fetchDesserts()
        }
    }
    
    init(mockDesserts: [Dessert]) {
        self.dessertListService = MockDessertListService() // Placeholder, won't be used
        self.desserts = mockDesserts
        self.isLoading = false
    }
    
    func fetchDesserts() async {
        isLoading = true
        errorMessage = nil
        do {
            let desserts = try await dessertListService.fetchDesserts()
            self.desserts = desserts
        } catch let apiError as APIError {
            self.errorMessage = apiError.localizedDescription
        } catch {
            self.errorMessage = APIError.unknown.localizedDescription
        }
        isLoading = false
    }
    
    var filteredDesserts: [Dessert] {
        if searchText.isEmpty {
            return desserts
        } else {
            return desserts.filter { $0.dessertName.localizedCaseInsensitiveContains(searchText) }
        }
    }
}
