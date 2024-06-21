//
//  PlaceholderView.swift
//  Desserts
//
//  Created by Shashank  on 6/19/24.
//

import SwiftUI

struct PlaceholderView: View {
    
    var imageText: String
    var captionText: String
    var fontColor: Color = Color.primary
    var fontSize: CGFloat = 275
    
    var body: some View {
        VStack(spacing: 15) {
                        
            Text(imageText)
                .font(.system(size: fontSize))
                .frame(width: 300, height: 300, alignment: .center)
            
            Text(captionText)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(fontColor)
        }
    }
}

// MARK: PREVIEW

#Preview {
    PlaceholderView(imageText: "🍰", captionText: "Choose a dessert 😋")
}
