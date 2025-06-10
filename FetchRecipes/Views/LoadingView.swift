//
//  LoadingView.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/9/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .transition(.opacity)
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 3)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray.opacity(0.3))
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 50, height: 50)
                        .foregroundColor(.accentColor)
                        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                        .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
                }
                
                Text("Loading recipes...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(radius: 10)
            )
        }
        .onAppear {
            isAnimating = true
        }
    }
}
