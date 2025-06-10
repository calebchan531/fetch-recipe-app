//
//  SettingsView.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/9/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var favoritesManager: FavoritesManager
    @Environment(\.dismiss) var dismiss
    @State private var showingClearAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Label("Total Favorites", systemImage: "heart.fill")
                            .foregroundColor(.red)
                        Spacer()
                        Text("\(favoritesManager.favoriteIDs.count)")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Statistics")
                }
                
                Section {
                    Button(action: { showingClearAlert = true }) {
                        Label("Clear All Favorites", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                    .disabled(favoritesManager.favoriteIDs.isEmpty)
                } header: {
                    Text("Data Management")
                } footer: {
                    Text("This will remove all your favorite recipes.")
                }
                
                Section {
                    Link(destination: URL(string: "https://github.com/yourusername/fetch-recipe-app")!) {
                        Label("View on GitHub", systemImage: "link")
                    }
                    
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Clear All Favorites?", isPresented: $showingClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    favoritesManager.clearAllFavorites()
                }
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
}
