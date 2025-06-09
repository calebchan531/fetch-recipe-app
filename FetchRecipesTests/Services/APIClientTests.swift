//
//  APIClientTests.swift
//  FetchRecipes
//
//  Created by Caleb Chan on 6/8/25.
//

import XCTest
@testable import FetchRecipes

class APIClientTests: XCTestCase {
    var sut: APIClient!
    
    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        sut = APIClient(session: session)
    }
    
    override func tearDown() {
        sut = nil
        MockURLProtocol.mockData = nil
        MockURLProtocol.mockError = nil
        super.tearDown()
    }
    
    func testFetchSuccess() async throws {
        // Given
        let expectedData = validRecipeJSON
        MockURLProtocol.mockData = expectedData
        MockURLProtocol.mockResponseCode = 200
        
        let url = URL(string: "https://test.com/recipes.json")!
        
        // When
        let response = try await sut.fetch(RecipeResponse.self, from: url)
        
        // Then
        XCTAssertEqual(response.recipes.count, 2)
    }
    
    func testFetchServerError() async {
        // Given
        MockURLProtocol.mockResponseCode = 500
        let url = URL(string: "https://test.com/recipes.json")!
        
        // When/Then
        do {
            _ = try await sut.fetch(RecipeResponse.self, from: url)
            XCTFail("Should throw server error")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.serverError(500))
        }
    }
}

// Mock URLProtocol for testing
class MockURLProtocol: URLProtocol {
    static var mockData: Data?
    static var mockError: Error?
    static var mockResponseCode: Int = 200
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: MockURLProtocol.mockResponseCode,
                httpVersion: nil,
                headerFields: nil
            )!
            
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data = MockURLProtocol.mockData {
                client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
        // Required but doesn't need to do anything
    }
}
