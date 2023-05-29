//
//  Network.swift
//  CommunityWeek2023
//
//  Created by Steffi Tan on 5/29/23.
//

import Foundation

struct Network {
  
  func sendRequestUsingCombine(api: APIResourceable) {
    
  }
  
  func sendRequestUsingAsyncAwait<T: Decodable>(api: APIResourceable) async -> T? {
    guard let url = api.url else { return nil }
  
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return nil }
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let dataModel = try decoder.decode(T.self, from: data)
      return dataModel
    } catch {
      return nil
    }
  }
}
