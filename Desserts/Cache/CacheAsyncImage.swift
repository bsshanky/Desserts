//
//  CacheAsyncImage.swift
//  Desserts
//
//  Created by Shashank  on 6/20/24.
//
// Implementation credit goes to Pedro Rojas - https://www.youtube.com/watch?v=KhGyiOk3Yzk

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {

    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    var body: some View {

        if let cached = ImageCache[url] {
            let _ = print("cached \(url.absoluteString)")
            content(.success(cached))
        } else {
            let _ = print("request \(url.absoluteString)")
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }

        return content(phase)
    }
}

fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]

    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}


struct CacheAsyncImage_Previews: PreviewProvider {
        
    static var previews: some View {
        CacheAsyncImage(
            url: URL(string: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")!
        ) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit() // Keep the natural aspect ratio
                    .frame(maxWidth: 300) // Adjust size as needed
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 10)
                    .padding()
            case .failure(_):
                Image(systemName: "birthday.cake.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 10)
                    .padding()
            @unknown default:
                EmptyView()
            }
        }
    }
}


