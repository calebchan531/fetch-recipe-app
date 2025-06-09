//
//  RecipeDetailView.Swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Large image
                if let urlString = recipe.photoUrlLarge,
                   let url = URL(string: urlString) {
                    CachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(maxHeight: 300)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(recipe.name)
                        .font(.largeTitle)
                        .bold()
                    
                    Label(recipe.cuisine, systemImage: "fork.knife")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    // Links
                    VStack(alignment: .leading, spacing: 8) {
                        if let sourceUrl = recipe.sourceUrl,
                           let url = URL(string: sourceUrl) {
                            Link(destination: url) {
                                Label("View Recipe", systemImage: "link")
                            }
                        }
                        
                        if let youtubeUrl = recipe.youtubeUrl,
                           let url = URL(string: youtubeUrl) {
                            Link(destination: url) {
                                Label("Watch on YouTube", systemImage: "play.rectangle")
                            }
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
