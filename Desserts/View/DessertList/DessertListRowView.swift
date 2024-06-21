//
//  DessertListRowView.swift
//  Desserts
//
//  Created by Shashank  on 6/18/24.
//

import SwiftUI

struct DessertListRowView: View {
    
    var dessertIconUrl: String?
    var dessertName: String?
    @State private var isLoading = true
    
    var body: some View {
        HStack {
            if let urlString = dessertIconUrl, let url = URL(string: urlString) {
                CacheAsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Rectangle() // Use a placeholder rectangle
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundColor(Color.gray)
                            .animatePlaceholder(isLoading: $isLoading) // Apply shiny animation
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .onAppear {
                                isLoading = false // Image loaded, stop animation
                            }
                    case .failure:
                        Image(systemName: "birthday.cake.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            if let mealName = dessertName {
                Text(mealName)
                    .font(.headline)
                    .padding(.leading, 10)
            }
        }
    }
}

// MARK: PREVIEW

#Preview {
    DessertListRowView(
        dessertIconUrl: "https://www.themealdb.com/images/media/meals/ryspuw1511786688.jpg",
        dessertName: "Summer Pudding"
    )
}
