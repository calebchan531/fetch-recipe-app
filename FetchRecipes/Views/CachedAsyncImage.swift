//
//  CachedAsyncImage.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import SwiftUI

struct CachedAsyncImage: View {
    let url: URL?
    let content: (Image) -> AnyView
    
    @StateObject private var loader: ImageLoader
    
    init(url: URL?, @ViewBuilder content: @escaping (Image) -> some View) {
        self.url = url
        self.content = { AnyView(content($0)) }
        self._loader = StateObject(wrappedValue: ImageLoader(url: url ?? URL(string: "https://invalid.url")!))
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                content(Image(uiImage: image))
            } else if loader.isLoading {
                ProgressView()
                    .frame(width: 50, height: 50)
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
            }
        }
        .task {
            if url != nil {
                await loader.load()
            }
        }
    }
}
