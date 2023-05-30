//
//  CommunityData.swift
//  CommunityWeek2023
//
//  Created by Steffi Tan on 5/29/23.
//

import Foundation

struct CommunityData: Codable {
  var countries: [Country]
  var events: [EventsPerCity]
//  var eventsPerCountry: [Eve]
}

struct Country: Codable {
  let flag: String
  let country: String
  var countryLabel: String {
    return country.replacingOccurrences(of: "_", with: " ").capitalized
  }
}

struct EventsPerCity: Codable, Identifiable, Hashable {
  static func == (lhs: EventsPerCity, rhs: EventsPerCity) -> Bool {
    lhs.id == rhs.id
  }
  
  public func hash(into hasher: inout Hasher) {
      return hasher.combine(id)
  }
  
  let id = UUID()
  let country: String
  let events: [Event]
  let cityLabel: String
  
}

struct Event: Codable, Identifiable {
  let id = UUID()
  let date: String
  let description: String
  let link: String
}
