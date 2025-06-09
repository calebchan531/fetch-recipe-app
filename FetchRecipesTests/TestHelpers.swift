//
//  TestHelpers.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import Foundation
import XCTest

extension XCTestCase {
    var validRecipeJSON: Data {
        """
        {
            "recipes": [
                {
                    "uuid": "123e4567-e89b-12d3-a456-426614174000",
                    "name": "Test Recipe",
                    "cuisine": "Italian",
                    "photo_url_small": "https://example.com/small.jpg",
                    "photo_url_large": "https://example.com/large.jpg",
                    "source_url": "https://example.com/recipe",
                    "youtube_url": "https://youtube.com/watch?v=123"
                },
                {
                    "uuid": "223e4567-e89b-12d3-a456-426614174000",
                    "name": "Another Recipe",
                    "cuisine": "Mexican",
                    "photo_url_small": "https://example.com/small2.jpg"
                }
            ]
        }
        """.data(using: .utf8)!
    }
    
    var emptyRecipeJSON: Data {
        """
        {
            "recipes": []
        }
        """.data(using: .utf8)!
    }
    
    var malformedJSON: Data {
        """
        {
            "recipes": [
                {
                    "uuid": "123",
                    "name": null,
                    "cuisine": "Italian"
                }
            ]
        }
        """.data(using: .utf8)!
    }
    
    func createTestRecipe() -> Recipe {
        Recipe(
            uuid: "test-uuid",
            name: "Test Recipe",
            cuisine: "Italian",
            photoUrlLarge: "https://example.com/large.jpg",
            photoUrlSmall: "https://example.com/small.jpg",
            sourceUrl: "https://example.com/recipe",
            youtubeUrl: "https://youtube.com/watch?v=test"
        )
    }
}
