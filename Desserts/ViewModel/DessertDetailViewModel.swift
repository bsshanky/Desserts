//
//  DessertDetailViewModel.swift
//  Desserts
//
//  Created by Shashank  on 6/19/24.
//

import Foundation
import SwiftUI

@MainActor
class DessertDetailViewModel: ObservableObject {
    @Published var dessertDetail: DessertDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let dessertDetailService: DessertDetailProtocol
    
    init(service: DessertDetailProtocol = DessertDetailService()) {
        self.dessertDetailService = service
    }
    
    // Initializer for using mock data
    init(mockDetail: DessertDetail, service: DessertDetailProtocol = MockDessertDetailService()) {
        self.dessertDetail = mockDetail
        self.isLoading = false
        self.errorMessage = nil
        self.dessertDetailService = service
    }
    
    func fetchDessertDetail(for id: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let detail = try await dessertDetailService.fetchDessertDetail(by: id)
            self.dessertDetail = detail
        } catch let apiError as APIError {
            self.errorMessage = apiError.localizedDescription
        } catch {
            self.errorMessage = APIError.unknown.localizedDescription
        }
        
        isLoading = false
    }
}

