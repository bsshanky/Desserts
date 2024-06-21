//
//  DessertImageView.swift
//  Desserts
//
//  Created by Shashank  on 6/19/24.
//

import SwiftUI

struct DessertImageView: View {
    let urlString: String?
    
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if let urlString = urlString, let url = URL(string: urlString) {
                ZStack {
                    // Background blurred image
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill() // Fill the background
                                .frame(height: 400)
                                .clipped()
                                .blur(radius: 10) // Apply blur effect
                                .overlay(
                                    // Gradient overlay to enhance text visibility
                                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                                )

                        case .failure, .empty:
                            Color(.gray).opacity(0.3)
                                .frame(height: 400)

                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    // Foreground image without blur, scaled naturally
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit() // Keep the natural aspect ratio
                                .frame(maxWidth: 300) // Adjust size as needed
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 10)
                                .padding()
                                .onAppear {
                                    isLoading = false // Image loaded, stop animation
                                }

                        case .failure, .empty:
                            Image(systemName: "birthday.cake.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 10)
                                .padding()
                                .onAppear {
                                    isLoading = false // Image failed, stop animation
                                }

                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 400)
    }
}

// MARK: PREVIEW

#Preview {
    DessertImageView(urlString: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
}
