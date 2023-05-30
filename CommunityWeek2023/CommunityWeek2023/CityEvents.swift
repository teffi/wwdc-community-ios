//
//  CityEvents.swift
//  CommunityWeek2023
//
//  Created by Steffi Tan on 5/30/23.
//

import SwiftUI
import SafariServices

struct CityEvents: View {
  let cityData: EventsPerCity
  @State var selectedEvent: Event?
  
  var body: some View {
    List {
      Section {
        ForEach(cityData.events) { event in
          NavigationLink(value: event) {
            VStack(alignment: .leading, spacing: 6) {
              HStack {
                Text(event.description)
                  .font(.headline)
                  .fontWeight(.bold)
                Spacer()
                Image(systemName: "rectangle.fill.on.rectangle.fill")
              }
              Text(event.date)
                .font(.caption)
                .fontWeight(.bold)
            }
            .padding([.top,.bottom], 10)
            .padding([.leading,.trailing], 8)
          }
        }

      } header: {
        Text(cityData.cityLabel)
          .font(.title)
          .foregroundColor(.black)
      }
    }
    .listStyle(.plain)
    .navigationDestination(for: Event.self, destination: { event in
      Text(event.link)
    })
  }
}

//struct CityEvents_Previews: PreviewProvider {
//  static var previews: some View {
//    CityEvents()
//  }
//}
//

