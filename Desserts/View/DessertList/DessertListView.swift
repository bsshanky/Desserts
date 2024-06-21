//
//  DessertListView.swift
//  Desserts
//
//  Created by Shashank  on 6/18/24.
//

import SwiftUI

struct DessertListView: View {
        
    @EnvironmentObject var network: Network
    @StateObject private var viewModel: DessertListViewModel
    @Binding var selectedDessert: Dessert?
    
    init(selectedDessert: Binding<Dessert?>) {
        let viewModel = DessertListViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
        _selectedDessert = selectedDessert
    }
    
    // Secondary initializer to accept a custom view model, like for previews
    init(viewModel: DessertListViewModel, selectedDessert: Binding<Dessert?> = .constant(nil)) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _selectedDessert = selectedDessert
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading desserts 🍰 ...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else if let errorMessage = viewModel.errorMessage {
                PlaceholderView(imageText: "⚠️",
                                captionText: errorMessage,
                                fontColor: Color(uiColor: .systemRed),
                                fontSize: 200)
            } else {
                List(selection: $selectedDessert) {
                    ForEach(viewModel.filteredDesserts, id: \.self) { dessert in
                        DessertListRowView(dessertIconUrl: dessert.dessertThumbUrl, dessertName: dessert.dessertName)
                        .padding(5)
                    }
                }
            }
        }
        .navigationTitle("Desserts")
        .searchable(text: $viewModel.searchText)
        .onAppear {
            if viewModel.desserts.isEmpty {
                Task {
                    await viewModel.fetchDesserts()
                }
            }
        }
        .onChange(of: network.connected) {
            if network.connected {
                Task {
                    await viewModel.fetchDesserts()
                }
            }
        }

    }
}

// MARK: PREVIEW

#Preview {
    let mockDesserts = [
        Dessert(id: "53049", dessertName: "Apam balik", dessertThumbUrl: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg"),
        Dessert(id: "52893", dessertName: "Apple & Blackberry Crumble", dessertThumbUrl: "https://www.themealdb.com/images/media/meals/xvsurr1511719182.jpg"),
        Dessert(id: "52768", dessertName: "Apple Frangipan Tart", dessertThumbUrl: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg")
    ]
    
    // Create a mock view model with the mock data
    let mockVM = DessertListViewModel(mockDesserts: mockDesserts)
    let mockNetwork = Network(forPreview: true)

    
    // Use the secondary initializer to inject the mock view model
    return DessertListView(viewModel: mockVM).environmentObject(mockNetwork)
}
