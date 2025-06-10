//
//  RecipeDetailView.Swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    let isFavorite: Bool
    let onFavoriteTap: () -> Void
    
    @State private var imageHeight: CGFloat = 300
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero image with parallax effect
                GeometryReader { geometry in
                    if let urlString = recipe.photoUrlLarge,
                       let url = URL(string: urlString) {
                        CachedAsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: geometry.size.width,
                                    height: imageHeight + (geometry.frame(in: .global).minY > 0 ? geometry.frame(in: .global).minY : 0)
                                )
                                .clipped()
                                .offset(y: geometry.frame(in: .global).minY > 0 ? -geometry.frame(in: .global).minY : 0)
                        }
                    } else {
                        Rectangle()
                            .fill(LinearGradient(
                                colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray.opacity(0.5))
                            )
                    }
                }
                .frame(height: imageHeight)
                
                // Content
                VStack(alignment: .leading, spacing: 20) {
                    // Title and favorite button
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(recipe.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            HStack(spacing: 12) {
                                Label(recipe.cuisine, systemImage: "fork.knife.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.orange)
                            }
                        }
                        
                        Spacer()
                        
                        FavoriteButton(isFavorite: isFavorite, action: onFavoriteTap)
                    }
                    
                    // Action buttons
                    HStack(spacing: 12) {
                        if let sourceUrl = recipe.sourceUrl, let url = URL(string: sourceUrl) {
                            ActionButton(
                                title: "View Recipe",
                                icon: "book.fill",
                                color: .blue,
                                url: url
                            )
                        }
                        
                        if let youtubeUrl = recipe.youtubeUrl, let url = URL(string: youtubeUrl) {
                            ActionButton(
                                title: "Watch Video",
                                icon: "play.rectangle.fill",
                                color: .red,
                                url: url
                            )
                        }
                    }
                    
                    // Additional info section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About this recipe")
                            .font(.headline)
                        
                        Text("Discover the authentic flavors of \(recipe.cuisine) cuisine with this delicious \(recipe.name). Perfect for any occasion!")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.top)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(Color(UIColor.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: -10)
                )
                .offset(y: -30)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

struct FavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    isPressed = false
                }
            }
        }) {
            ZStack {
                Circle()
                    .fill(isFavorite ? Color.red : Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.title2)
                    .foregroundColor(isFavorite ? .white : .gray)
                    .scaleEffect(isPressed ? 1.2 : 1.0)
            }
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let url: URL
    
    var body: some View {
        Link(destination: url) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .fontWeight(.medium)
            }
            .font(.subheadline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
            )
        }
    }
}
