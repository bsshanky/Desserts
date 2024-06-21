//
//  DessertDetailview.swift
//  Desserts
//
//  Created by Shashank  on 6/19/24.
//

import SwiftUI

struct DessertDetailView: View {
    
    @EnvironmentObject var network: Network
    @Binding var selectedDessert: Dessert?
    @StateObject private var viewModel: DessertDetailViewModel

    init(selectedDessert: Binding<Dessert?>) {
        let viewModel = DessertDetailViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
        _selectedDessert = selectedDessert
    }
    
    // Secondary initializer to accept a custom view model, like for previews
    init(viewModel: DessertDetailViewModel, selectedDessert: Binding<Dessert?>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _selectedDessert = selectedDessert
    }
    
    var body: some View {
        if let selectedDessert = selectedDessert {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading 🧁 Details ...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding()
                        .frame(alignment: .center)

                } else if let errorMessage = viewModel.errorMessage {
                    
                    PlaceholderView(imageText: "⚠️", captionText: errorMessage, fontColor: Color(uiColor: .systemRed))

                } else if let dessertDetail = viewModel.dessertDetail {
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            DessertImageView(urlString: selectedDessert.dessertThumbUrl)
                            
                            HStack {
                                Text(selectedDessert.dessertName)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal, 25)
                            
                            VStack(spacing: 15) {
                                sectionView(header: "Country of Origin") {
                                    HStack{
                                        Text(dessertDetail.countryOfOrigin)
                                        Spacer()
                                    }
                                }
                                
                                sectionView(header: "YouTube Tutorial") {
                                    
                                    if let youtubeURL = dessertDetail.youtubeURL, let url = URL(string: youtubeURL) {
                                        HStack {
                                            Link(destination: url) {
                                                Text(youtubeURL)
                                                    .foregroundColor(Color(uiColor: .systemBlue))
                                                    .underline()
                                                    .padding(.leading)
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                    } else {
                                        Text("No YouTube link available")
                                            .padding(.leading)
                                    }
                                }
                                
                                sectionView(header: "Instructions") {
                                    Text(dessertDetail.instructions)
                                }
                                
                                sectionView(header: "Ingredients") {
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(Array(dessertDetail.ingredients.enumerated()), id: \.element) { index, ingredient in
                                            VStack(alignment: .leading) {
                                                Text(ingredient)
                                                    .padding(.vertical, 5)
                                                if index < dessertDetail.ingredients.count - 1 {
                                                    Divider()
                                                }
                                            }
                                        }
                                    }
                                    .background(Color(uiColor: .systemGray5))
                                    .cornerRadius(10)
                                    .padding(.bottom)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchDessertDetail(for: selectedDessert.id)
                }
            }
            .onChange(of: selectedDessert) {
                Task {
                    await viewModel.fetchDessertDetail(for: selectedDessert.id)
                }
            }
            .onChange(of: network.connected) {
                if network.connected {
                    Task {
                        await viewModel.fetchDessertDetail(for: selectedDessert.id)
                    }
                }
            }

        } else {
            PlaceholderView(imageText: "🍰", captionText: "Choose a dessert 😋")
        }
    }

    // Helper function to create sections
    @ViewBuilder
    private func sectionView<Content: View>(header: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            
            Text(header)
                .font(.headline)
                .foregroundStyle(Color(uiColor: .systemPurple))
            content()
                .padding()
                .background(Color(uiColor: .systemGray5))
                .cornerRadius(10)
        }
    }
}

 // MARK: PREVIEW

struct DessertDetailView_Previews: PreviewProvider {
    @State static var mockDessert: Dessert? = Dessert(id: "53049", dessertName: "Apam balik", dessertThumbUrl: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
    
    static var mockDetail = DessertDetail(
        id: "53049",
        countryOfOrigin: "Malaysian",
        instructions: "Mix milk, oil and egg together. Sift flour, baking powder and salt into the mixture. Stir well until all ingredients are combined evenly.\r\n\r\nSpread some batter onto the pan. Spread a thin layer of batter to the side of the pan. Cover the pan for 30-60 seconds until small air bubbles appear.\r\n\r\nAdd butter, cream corn, crushed peanuts and sugar onto the pancake. Fold the pancake into half once the bottom surface is browned.\r\n\r\nCut into wedges and best eaten when it is warm.",
        youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg",
        ingredients: [
            "200ml Milk",
            "60ml Oil",
            "2 Eggs",
            "1600g Flour",
            "3 tsp Baking Powder",
            "1/2 tsp Salt",
            "25g Unsalted Butter",
            "45g Sugar",
            "3 tbs Peanut Butter"
        ]
    )
    
    // Create a mock view model with the mock data
    @StateObject static var mockVM = DessertDetailViewModel(mockDetail: mockDetail)
    static let mockNetwork = Network(forPreview: true)

    static var previews: some View {
        DessertDetailView(viewModel: mockVM, selectedDessert: $mockDessert).environmentObject(mockNetwork)
            
    }
}

