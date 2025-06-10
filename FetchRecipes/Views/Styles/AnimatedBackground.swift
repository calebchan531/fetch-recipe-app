//
//  AnimatedBackground.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/9/25.
//
// More on animated backgrounds: https://mayankchoudharydotcom.medium.com/creating-an-animated-background-using-swiftui-4c5809b6ff6c

import SwiftUI

struct AnimatedBackground: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // The base gradient
                LinearGradient(
                    colors: [
                        Color(hex: "FF6B6B").opacity(0.1),
                        Color(hex: "4ECDC4").opacity(0.1),
                        Color(hex: "45B7D1").opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // For animated circles
                ForEach(0..<3) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(hex: "FF6B6B").opacity(0.3),
                                    Color(hex: "4ECDC4").opacity(0.1)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 100
                            )
                        )
                        .frame(width: 200, height: 200)
                        .offset(
                            x: animate ? CGFloat.random(in: -100...100) : 0,
                            y: animate ? CGFloat.random(in: -100...100) : 0
                        )
                        .blur(radius: 20)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 5...8))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.5),
                            value: animate
                        )
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            animate = true
        }
    }
}
