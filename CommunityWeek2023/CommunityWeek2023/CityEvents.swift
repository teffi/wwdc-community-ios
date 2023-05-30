//
//  CityEvents.swift
//  CommunityWeek2023
//
//  Created by Steffi Tan on 5/30/23.
//

import SwiftUI

struct CityEvents: View {
  let cityData: EventsPerCity
  
  var body: some View {
    Text(cityData.cityLabel)
    List {
      ForEach(cityData.events) { event in
        VStack(alignment: .leading, spacing: 8) {
          HStack(spacing: 4){
            Text(event.date)
            Text(event.description)
          }
          Text(event.link).font(.footnote)
        }
      }
    }
  }
}

//struct CityEvents_Previews: PreviewProvider {
//  static var previews: some View {
//    CityEvents()
//  }
//}
//

