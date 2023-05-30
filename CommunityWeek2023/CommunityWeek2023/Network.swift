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
  
  // TODO: Add throwing of error.
  // Possible errors:
  //  - http status code
  //  - decoding error
  
  func sendRequestUsingAsyncAwait<T: Decodable>(api: APIResourceable) async throws -> T? {
    guard let url = api.url else { throw RequestError.incorrectUrl }
  
    do {
      let (data, response) = try await URLSession.shared.data(from: url)
      
      //  Throw for non http url response
      guard let httpResponse = response as? HTTPURLResponse else {
        throw RequestError.invalidResponse
      }
      
      //  Throw for non success status code.
      guard httpResponse.status == .success else {
        throw RequestError.httpStatus(code: httpResponse.status)
      }
            
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let dataModel = try decoder.decode(T.self, from: data)
      return dataModel
      
    } catch let error as DecodingError {
      // Checking for type use `catch is Error`
      throw RequestError.decoding(type: error)
    } catch is URLError {
      throw RequestError.failedToSend
    }
  }
}

extension HTTPURLResponse {
  var status: HTTPCode {
//    guard let statusCode = statusCode else { return .undefined }
    return HTTPCode(rawValue: statusCode) ?? .undefined
  }
}

enum HTTPCode: Int {
  case success = 200
  case unauthorized = 401
  case notFound = 404
  case serverError = 500
  case undefined = 0
}

enum RequestError: Error {
  case incorrectUrl
  case failedToSend
  case invalidResponse
  case httpStatus(code: HTTPCode)
  case decoding(type: DecodingError)
  case undefined
  
  var message: String {
    switch self {
    case .incorrectUrl:
      return "incorrect url"
    case .failedToSend:
      return "failed to send"
    case .invalidResponse:
      return "invalid response"
    case .httpStatus(let code):
      return "http status code \(code.rawValue)"
    case .decoding(let type):
      return "data can't be decoded \(type.errorDescription)"
    case .undefined:
      return "Unexpected issue"
    }
  }
}
//
//struct HTTPError: Error {
//  enum Code: Int {
//    case serverError = 500
//    case undefine
//  }
//}
