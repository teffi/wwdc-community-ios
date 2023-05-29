//
//  CommunityData.swift
//  CommunityWeek2023
//
//  Created by Steffi Tan on 5/29/23.
//

import Foundation

struct CommunityData: Codable {
  var countries: [Country]
}

struct Country: Codable {
  let flag: String
  let country: String
}
