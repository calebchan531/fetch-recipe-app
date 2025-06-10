//
//  CuisineChart.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/9/25.
//

import Foundation
import SwiftUI

struct CuisineChart: View {
    let recipes: [Recipe]
    
    private var cuisineCounts: [(String, Int)] {
        let counts = Dictionary(grouping: recipes) { $0.cuisine }
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
            .prefix(3)
        return Array(counts)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(cuisineCounts, id: \.0) { cuisine, count in
                VStack(spacing: 2) {
                    Text("\(count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                    Text(cuisine)
                        .font(.caption2)
                        .lineLimit(1)
                }
                .frame(width: 50)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.accentColor.opacity(0.1))
                )
            }
        }
    }
}
