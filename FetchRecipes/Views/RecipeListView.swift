//
//  RecipeListView.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel()
    @State private var showingSettings = false
    @State private var selectedRecipe: Recipe?
    @Namespace private var animation
    
    var body: some View {
        NavigationView {
            ZStack {
                // Animated background
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        HeroHeader(
                            recipeCount: viewModel.filteredAndSortedRecipes.count,
                            filterOption: viewModel.filterOption,
                            searchText: viewModel.searchText
                        )
                        .padding(.bottom, 20)
                        
                        // Recipe grid
                        LazyVStack(spacing: 0) {
                            ForEach(Array(viewModel.filteredAndSortedRecipes.enumerated()), id: \.element.id) { index, recipe in
                                NavigationLink(destination: RecipeDetailView(
                                    recipe: recipe,
                                    isFavorite: viewModel.isFavorite(recipe),
                                    onFavoriteTap: { viewModel.toggleFavorite(for: recipe) }
                                )) {
                                    RecipeRowView(
                                        recipe: recipe,
                                        isFavorite: viewModel.isFavorite(recipe),
                                        onFavoriteTap: {
                                            withAnimation(.spring()) {
                                                viewModel.toggleFavorite(for: recipe)
                                            }
                                        }
                                    )
                                    .matchedGeometryEffect(id: recipe.id, in: animation)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                                .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(Double(index) * 0.05), value: viewModel.filteredAndSortedRecipes)
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
                .overlay(alignment: .bottom) {
                    FloatingTabBar(
                        filterOption: $viewModel.filterOption,
                        sortOption: $viewModel.sortOption,
                        onSettingsTap: { showingSettings = true }
                    )
                }
            }
            .navigationBarHidden(false)
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search recipes..."
            )
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                await viewModel.loadRecipes()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(favoritesManager: viewModel.favoritesManager)
            }
            .overlay {
                if viewModel.isLoading {
                    PremiumLoadingView()
                }
            }
        }
    }
}
