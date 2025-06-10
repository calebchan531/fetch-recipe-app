//
//  HeroHeader.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/9/25.
//

import Foundation
import SwiftUI

struct HeroHeader: View {
    let recipeCount: Int
    let filterOption: FilterOption
    let searchText: String
    
    @State private var animate = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text("Discover") // Potential for a toggled Header for updates later in developement.
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "FF6B6B"), Color(hex: "4ECDC4")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text("Amazing Recipes")
                .font(.system(size: 36, weight: .medium, design: .rounded))
                .foregroundColor(.primary)
            
            // Stats card
            HStack(spacing: 20) {
                StatCard(
                    number: recipeCount,
                    label: filterOption == .favorites ? "Favorites" : "Recipes",
                    icon: filterOption == .favorites ? "heart.fill" : "fork.knife",
                    color: Color(hex: "FF6B6B")
                )
                
                if !searchText.isEmpty {
                    StatCard(
                        number: recipeCount,
                        label: "Results",
                        icon: "magnifyingglass",
                        color: Color(hex: "4ECDC4")
                    )
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 60)
    }
}

struct StatCard: View {
    let number: Int
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(number)")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                Text(label)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}
