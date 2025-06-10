//
//  PremiumLoadingView.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/9/25.
// 

import Foundation
import SwiftUI

struct PremiumLoadingView: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            // Blurred background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .blur(radius: 10)
            
            VStack(spacing: 24) {
                ZStack {
                    // Animated rings
                    ForEach(0..<3) { index in
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "FF6B6B").opacity(0.8 - Double(index) * 0.2),
                                        Color(hex: "4ECDC4").opacity(0.8 - Double(index) * 0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .frame(
                                width: CGFloat(50 + index * 20),
                                height: CGFloat(50 + index * 20)
                            )
                            .rotationEffect(.degrees(rotation + Double(index * 120)))
                            .scaleEffect(scale)
                    }
                    
                    Image(systemName: "fork.knife")
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                Text("Loading delicious recipes...")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
            )
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                scale = 1.2
            }
        }
    }
}
