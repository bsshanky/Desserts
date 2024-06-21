//
//  DessertDetailViewModel_Tests.swift
//  DessertsTests
//
//  Created by Shashank  on 6/20/24.
//

import XCTest
@testable import Desserts

final class DessertDetailViewModel_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    // Test Case for a Successful Fetch of Dessert Detail
    @MainActor func test_DessertDetailViewModel_fetchDessertDetail_success() async {
        // Given
        let mockDetail = DessertDetail(
            id: "53049",
            countryOfOrigin: "Malaysia",
            instructions: "Mix and bake",
            youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg",
            ingredients: ["50g Sugar", "50g Flour", "5 Eggs", "250ml Water"]
        )
        
        let mockService = MockDessertDetailService()
        mockService.mockDessertDetail = mockDetail
        let viewModel = DessertDetailViewModel(service: mockService)
        
        // When
        await viewModel.fetchDessertDetail(for: "53049")
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.dessertDetail)
        XCTAssertEqual(viewModel.dessertDetail?.id, "53049")
        XCTAssertEqual(viewModel.dessertDetail?.countryOfOrigin, "Malaysia")
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // Test Case for Bad URL Error
    @MainActor func test_DessertDetailViewModel_fetchDessertDetail_badURL() async {
        // Given
        let mockService = MockDessertDetailService()
        mockService.shouldReturnError = true
        mockService.error = APIError.badURL
        let viewModel = DessertDetailViewModel(service: mockService)
        
        // When
        await viewModel.fetchDessertDetail(for: "invalid_id")
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.dessertDetail)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, APIError.badURL.localizedDescription)
    }
    
    // Test Case for Bad Response Error
    @MainActor func test_DessertDetailViewModel_fetchDessertDetail_badResponse() async {
        // Given
        let mockService = MockDessertDetailService()
        mockService.shouldReturnError = true
        mockService.error = APIError.badResponse(statusCode: 404)
        let viewModel = DessertDetailViewModel(service: mockService)
        
        // When
        await viewModel.fetchDessertDetail(for: "53049")
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.dessertDetail)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, APIError.badResponse(statusCode: 404).localizedDescription)
    }
    
    // Test Case for Parsing Error
    @MainActor func test_DessertDetailViewModel_fetchDessertDetail_parsingError() async {
        // Given
        let mockService = MockDessertDetailService()
        mockService.shouldReturnError = true
        let decodingError = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Test decoding error"))
        mockService.error = APIError.parsing(decodingError)
        let viewModel = DessertDetailViewModel(service: mockService)
        
        // When
        await viewModel.fetchDessertDetail(for: "53049")
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.dessertDetail)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, APIError.parsing(decodingError).localizedDescription)
    }
    
    // Test Case for Unknown Error
    @MainActor func test_DessertDetailViewModel_fetchDessertDetail_unknownError() async {
        // Given
        let mockService = MockDessertDetailService()
        mockService.shouldReturnError = true
        mockService.error = APIError.unknown
        let viewModel = DessertDetailViewModel(service: mockService)
        
        // When
        await viewModel.fetchDessertDetail(for: "53049")
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.dessertDetail)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, APIError.unknown.localizedDescription)
    }
}
