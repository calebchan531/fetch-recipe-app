//
//  GlassmorphicCard.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/9/25.
//
// Source: https://medium.com/@garejakirit/implementing-glassmorphism-effect-in-swiftui-57cbe0b6f533
import SwiftUI

struct GlassomorphicCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(
                ZStack {
                    // Blurs
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                    
                    // Gradients the border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.6),
                                    Color.white.opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
