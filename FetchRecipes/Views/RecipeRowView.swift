//
//  RecipeRowView.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import SwiftUI

struct RecipeRowView: View {
    let recipe: Recipe
    let isFavorite: Bool
    let onFavoriteTap: () -> Void
    
    @State private var isPressed = false
    @State private var showContent = false
    
    var body: some View {
        GlassomorphicCard {
            HStack(spacing: 16) {
                // Animated image container
                ZStack {
                    // Gradients background
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: cuisineGradient(for: recipe.cuisine),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 85, height: 85)
                    
                    if let urlString = recipe.photoUrlSmall,
                       let url = URL(string: urlString) {
                        CachedAsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                    } else {
                        Image(systemName: "photo")
                            .font(.title)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                .scaleEffect(showContent ? 1 : 0.8)
                .opacity(showContent ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.1), value: showContent)
                
                // Content
                VStack(alignment: .leading, spacing: 8) {
                    Text(recipe.name)
                        .font(.system(.headline, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)
                            .foregroundColor(cuisineColor(for: recipe.cuisine))
                        
                        Text(recipe.cuisine)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        // badges
                        HStack(spacing: 4) {
                            if recipe.sourceUrl != nil {
                                MediaBadge(icon: "doc.text.fill", color: .blue)
                            }
                            if recipe.youtubeUrl != nil {
                                MediaBadge(icon: "play.fill", color: .red)
                            }
                        }
                    }
                }
                .opacity(showContent ? 1 : 0)
                .offset(x: showContent ? 0 : 20)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: showContent)
                
                Spacer()
                
                // Favorite button
                FavoriteButtonCompact(
                    isFavorite: isFavorite,
                    action: onFavoriteTap
                )
                .opacity(showContent ? 1 : 0)
                .scaleEffect(showContent ? 1 : 0.5)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.3), value: showContent)
            }
            .padding(16)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .onAppear {
            withAnimation {
                showContent = true
            }
        }
    }
    
    func cuisineGradient(for cuisine: String) -> [Color] {
        switch cuisine.lowercased() {
        case "italian": return [Color(hex: "FF6B6B"), Color(hex: "FF8E53")]
        case "mexican": return [Color(hex: "F2994A"), Color(hex: "F2C94C")]
        case "british": return [Color(hex: "667EEA"), Color(hex: "764BA2")]
        case "american": return [Color(hex: "4ECDC4"), Color(hex: "44A08D")]
        default: return [Color(hex: "A8E6CF"), Color(hex: "DCEDC1")]
        }
    }
    
    func cuisineColor(for cuisine: String) -> Color {
        cuisineGradient(for: cuisine).first ?? .gray
    }
}

struct MediaBadge: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Image(systemName: icon)
            .font(.caption2)
            .foregroundColor(color)
            .padding(4)
            .background(
                Circle()
                    .fill(color.opacity(0.2))
            )
    }
}

struct FavoriteButtonCompact: View {
    let isFavorite: Bool
    let action: () -> Void
    
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                scale = 0.8
                rotation += 360
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    scale = 1.0
                }
            }
            action()
            
            // Enhanced haptics
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.prepare()
            impactFeedback.impactOccurred()
        }) {
            ZStack {
                // Animated background
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isFavorite ?
                                [Color(hex: "FF6B6B"), Color(hex: "FF8E53")] :
                                [Color.gray.opacity(0.1), Color.gray.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 44, height: 44)
                
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 20))
                    .foregroundColor(isFavorite ? .white : .gray)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
