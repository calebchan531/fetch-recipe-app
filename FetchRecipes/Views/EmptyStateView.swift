//
//  EmptyStateView.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import SwiftUI

struct EmptyStateView: View {
    let message: String
    let systemImage: String
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.gray.opacity(0.1), Color.gray.opacity(0.05)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
                
                Image(systemName: systemImage)
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                    .symbolRenderingMode(.hierarchical)
            }
            
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            isAnimating = true
        }
    }
}
