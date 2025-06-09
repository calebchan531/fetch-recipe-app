//
//  RecipeListView.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.showEmptyState {
                    EmptyStateView(
                        message: "No recipes available",
                        systemImage: "tray"
                    )
                } else if let error = viewModel.errorMessage {
                    EmptyStateView(
                        message: error,
                        systemImage: "exclamationmark.triangle"
                    )
                } else {
                    recipeList
                }
            }
            .navigationTitle("Recipes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    sortMenu
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search recipes")
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                await viewModel.loadRecipes()
            }
        }
    }
    
    private var recipeList: some View {
        List {
            ForEach(viewModel.filteredAndSortedRecipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    RecipeRowView(recipe: recipe)
                }
            }
        }
        .listStyle(PlainListStyle())
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading recipes...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.1))
            }
        }
    }
    
    private var sortMenu: some View {
        Menu {
            Picker("Sort by", selection: $viewModel.sortOption) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down.circle")
        }
    }
}
