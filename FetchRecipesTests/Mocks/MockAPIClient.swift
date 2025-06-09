//
//  MockAPIClient.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import Foundation
@testable import FetchRecipes

class MockAPIClient: APIClientProtocol {
    var mockData: Data?
    var mockError: Error?
    
    func fetch<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData else {
            throw NetworkError.noData
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
