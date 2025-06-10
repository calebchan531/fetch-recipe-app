//
//  FloatingTabBar.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/9/25.
//

import Foundation
import SwiftUI

struct FloatingTabBar: View {
    @Binding var filterOption: FilterOption
    @Binding var sortOption: SortOption
    let onSettingsTap: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            // Filter button
            TabBarButton(
                icon: filterOption == .favorites ? "heart.fill" : "square.grid.2x2.fill",
                isSelected: filterOption == .favorites,
                color: Color(hex: "FF6B6B")
            ) {
                withAnimation(.spring()) {
                    filterOption = filterOption == .all ? .favorites : .all
                }
            }
            
            Spacer()
            
            // Sort menu
            Menu {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button(action: { sortOption = option }) {
                        Label(option.rawValue, systemImage: sortIcon(for: option))
                    }
                }
            } label: {
                TabBarButton(
                    icon: "arrow.up.arrow.down",
                    isSelected: sortOption != .none,
                    color: Color(hex: "4ECDC4")
                ) { }
            }
            
            Spacer()
            
            // Settings
            TabBarButton(
                icon: "gearshape.fill",
                isSelected: false,
                color: Color(hex: "45B7D1")
            ) {
                onSettingsTap()
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 16)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.white.opacity(0.1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
    
    func sortIcon(for option: SortOption) -> String {
        switch option {
        case .none: return "list.bullet"
        case .name: return "textformat"
        case .cuisine: return "fork.knife"
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                }
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? color : .gray)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}
