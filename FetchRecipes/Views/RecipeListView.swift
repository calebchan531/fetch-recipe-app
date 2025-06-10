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
    @FocusState private var isSearchFocused: Bool
    @Namespace private var animation

    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()

                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search recipes...", text: $viewModel.searchText)
                            .focused($isSearchFocused)
                            .textFieldStyle(PlainTextFieldStyle())
                            .submitLabel(.search)

                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                                isSearchFocused = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding([.horizontal, .top], 16)

                    ScrollView {
                        VStack(spacing: 0) {
                            if !isSearchFocused && !viewModel.filteredAndSortedRecipes.isEmpty {
                                HeroHeader(
                                    recipeCount: viewModel.filteredAndSortedRecipes.count,
                                    filterOption: viewModel.filterOption,
                                    searchText: viewModel.searchText
                                )
                                .padding(.bottom, 20)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                            }

                            if viewModel.showEmptyState {
                                EmptyStateView(
                                    message: viewModel.emptyStateMessage,
                                    systemImage: viewModel.filterOption == .favorites ? "heart.slash" : "tray"
                                )
                                .frame(height: 400)
                                .transition(.opacity.combined(with: .scale))
                            } else if let error = viewModel.errorMessage {
                                EmptyStateView(
                                    message: error,
                                    systemImage: "exclamationmark.triangle"
                                )
                                .frame(height: 400)
                                .transition(.opacity.combined(with: .scale))
                            } else {
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
                    }
                    .animation(.easeInOut, value: isSearchFocused)
                }
                .overlay(alignment: .bottom) {
                    if !isSearchFocused {
                        FloatingTabBar(
                            filterOption: $viewModel.filterOption,
                            sortOption: $viewModel.sortOption,
                            onSettingsTap: { showingSettings = true }
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .navigationBarHidden(true)
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
            .onTapGesture {
                if isSearchFocused {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    withAnimation {
                        isSearchFocused = false
                    }
                }
            }
        }
    }
}
