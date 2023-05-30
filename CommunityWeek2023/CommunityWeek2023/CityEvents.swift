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
  
  var body: some View {
    List {
      Section {
        ForEach(cityData.events) { event in
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
          .background {
            NavigationLink(value: event) {
              EmptyView()
            }
            // Why set to 0: NavigationLink adds an arrow icon to a list item.
            // To hide the icon, we set 0 opacity and place navlink as background so it wont take up any space on the row.
            .opacity(0)
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

