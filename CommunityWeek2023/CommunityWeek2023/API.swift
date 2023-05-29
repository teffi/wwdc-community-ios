//
//  API.swift
//  CommunityWeek2023
//
//  Created by Steffi Tan on 5/29/23.
//

import Foundation

protocol APIResourceable {
  var path: String { get set }
  var method: HTTPMethod { get set }
//  var queries: [URLQueryItem] { get set }
  var url: URL? { get }
}

extension APIResourceable {
  var url: URL? {
    return URL(string: path)
  }
}


enum HTTPMethod {
  case GET
}
