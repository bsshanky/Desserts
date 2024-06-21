//
//  DessertListViewModel_Tests.swift
//  DessertsTests
//
//  Created by Shashank  on 6/20/24.
//

import XCTest
@testable import Desserts

// Function naming structure: test_[struct or class]_[variable or function]_[expected behavior]

// Testing structure: Given, When, Then

final class DessertListViewModelTests: XCTestCase {
    
    let mockDesserts = [
        Dessert(id: "53049", dessertName: "Apam balik", dessertThumbUrl: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"),
        Dessert(id: "52893", dessertName: "Apple & Blackberry Crumble", dessertThumbUrl: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"),
        Dessert(id: "52768", dessertName: "Apple Frangipan Tart", dessertThumbUrl: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg")
    ]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor func test_DessertListViewModel_initialization_withMockData() {
        // Given
        
        
        // When
        let viewModel = DessertListViewModel(mockDesserts: mockDesserts)
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.desserts.count, mockDesserts.count)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    @MainActor func test_DessertListViewModel_fetchDesserts_success() async {
        // Given
        let mockService = MockDessertListService()
        mockService.mockDesserts = mockDesserts
        
        let viewModel = DessertListViewModel(service: mockService)
        
        // When
        await viewModel.fetchDesserts()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.desserts.count, mockService.mockDesserts.count)
        XCTAssertNil(viewModel.errorMessage)
    }

    // Test Case for Bad URL Error
    @MainActor
    func test_DessertListViewModel_fetchDesserts_badURL() async {
        // Given
        let mockService = MockDessertListService()
        mockService.shouldReturnError = true
        mockService.error = APIError.badURL
        let viewModel = DessertListViewModel(service: mockService)
        
        // When
        await viewModel.fetchDesserts()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.desserts.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, APIError.badURL.localizedDescription)
    }

    // Test Case for Bad Response Error
    @MainActor
    func test_DessertListViewModel_fetchDesserts_badResponse() async {
        // Given
        let mockService = MockDessertListService()
        mockService.shouldReturnError = true
        mockService.error = APIError.badResponse(statusCode: 404)
        let viewModel = DessertListViewModel(service: mockService)
        
        // When
        await viewModel.fetchDesserts()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.desserts.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, APIError.badResponse(statusCode: 404).localizedDescription)
    }

    // Test Case for Parsing Error
    @MainActor
    func test_DessertListViewModel_fetchDesserts_parsingError() async {
        // Given
        let mockService = MockDessertListService()
        mockService.shouldReturnError = true
        let decodingError = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Test decoding error"))
        mockService.error = APIError.parsing(decodingError)
        let viewModel = DessertListViewModel(service: mockService)
        
        // When
        await viewModel.fetchDesserts()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.desserts.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, APIError.parsing(decodingError).localizedDescription)
    }

    // Test Case for Unknown Error
    @MainActor
    func test_DessertListViewModel_fetchDesserts_unknownError() async {
        // Given
        let mockService = MockDessertListService()
        mockService.shouldReturnError = true
        mockService.error = APIError.unknown
        let viewModel = DessertListViewModel(service: mockService)
        
        // When
        await viewModel.fetchDesserts()
        
        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.desserts.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, APIError.unknown.localizedDescription)
    }
    
    @MainActor func test_DessertListViewModel_searchFunctionality_withSearchText() {
        // Given
        let viewModel = DessertListViewModel(mockDesserts: mockDesserts)
        
        // When
        viewModel.searchText = "Apple"
        
        // Then
        XCTAssertEqual(viewModel.filteredDesserts.count, 2)
        XCTAssertEqual(viewModel.filteredDesserts.first?.dessertName, "Apple & Blackberry Crumble")
    }
    
    @MainActor func test_DessertListViewModel_searchFunctionality_emptySearchText() {
        // Given

        let viewModel = DessertListViewModel(mockDesserts: mockDesserts)
        
        // When
        viewModel.searchText = ""
        
        // Then
        XCTAssertEqual(viewModel.filteredDesserts.count, mockDesserts.count)
    }
}

