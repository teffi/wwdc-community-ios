//
//  Network.swift
//  CommunityWeek2023
//
//  Created by Steffi Tan on 5/29/23.
//

import Foundation
import Combine

struct Network {
  // Use `Combine` - complete version
  func sendRequestUsingCombine<T: Decodable>(api: APIResourceable, type: T.Type) -> AnyPublisher<T, RequestError> {
    // Return an instant fail event.
    guard let url = api.url else {
      print("error url")
      return Fail<T, RequestError>(error: RequestError.incorrectUrl).eraseToAnyPublisher()
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return URLSession.shared.dataTaskPublisher(for: url)
      .tryMap { (data: Data, response: URLResponse) in
        //  Throw for non http url response
        guard let httpResponse = response as? HTTPURLResponse else {
          throw RequestError.invalidResponse
        }
        
        //  Throw for non success status code.
        guard httpResponse.status == .success else {
          throw RequestError.httpStatus(code: httpResponse.status)
        }
        return data
      }
      .decode(type: T.self, decoder: decoder)
      .mapError { error in
        print("error \(error)")
        // using .mapError operation, the expected return type is Error type.
        switch error {
        case is URLError:
          return RequestError.failedToSend
        case is DecodingError:
          return RequestError.decoding(type: (error as! DecodingError))
        case is RequestError:
          return error as! RequestError
        default:
          return RequestError.undefined
        }
      }
//      .catch { error in
//        // If catching, return type must be same with function – a Publisher type.
//        switch error {
//        case is URLError:
//          return Fail<T, RequestError>(error: RequestError.failedToSend)
//        case is DecodingError:
//          return Fail<T, RequestError>(error: RequestError.decoding(type: error as! DecodingError))
//        case is RequestError:
//          return Fail<T, RequestError>(error:error as! RequestError)
//        default:
//          return Fail<T, RequestError>(error: RequestError.undefined)
//        }
//        print("error \(error)")
//      }
      .eraseToAnyPublisher()
  }
  
  // Use `Combine` - missing returning of error for non-200 http status code
  func sendRequestUsingCombineWithoutHTTPResponseStatusError<T: Decodable>(api: APIResourceable, type: T.Type) -> AnyPublisher<T, RequestError> {
    // Return an instant fail event.
    guard let url = api.url else {
      print("error url")
      return Fail<T, RequestError>(error: RequestError.incorrectUrl).eraseToAnyPublisher()
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: T.self, decoder: decoder)
      .print("request sent")
      .mapError { error in
        print("error \(error)")
        // using .mapError operation, the expected return type is Error type.
        switch error {
        case is URLError:
          return RequestError.failedToSend
        case is DecodingError:
          return RequestError.decoding(type: (error as! DecodingError))
        default:
          return RequestError.undefined
        }
      }
      .eraseToAnyPublisher()
  }
  
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
