//
//  ContentView.swift
//  CommunityWeek2023
//
//  Created by Steffi Tan on 5/26/23.
//

import SwiftUI

struct ContentView: View {
  @State var isLoading = false
  @State var data: CommunityData?
  
  
    var body: some View {
      ZStack {
        if isLoading {
          VStack {
            Text("Loading data")
          }
        } else {
          List {
            ForEach(data?.countries ?? [], id:\.country) { item in
              Section {
                ForEach(data?.events.filter { $0.country == item.country } ?? []) { eventDetails in
                  VStack(alignment: .leading, spacing: 10) {
                    Text(eventDetails.cityLabel)
                      .font(.headline)
                    Text("\(eventDetails.events.count) events")
                      .opacity(0.7)
                      .font(.system(size: 14))
                      .padding(0)
                  }
                  .padding()
                }
              } header: {
                HStack {
                  Text(item.flag)
                  Text(item.countryLabel)
                }
              }
            }
          }
          .headerProminence(.increased)
        }
      }
      .navigationTitle("Community Week")
      .task {
        await loadData()
      }
    }
  
  @MainActor
  private func loadData() async {
    let network = Network()
    let resource = APIDataResource()
    isLoading = true
    data = await network.sendRequestUsingAsyncAwait(api: resource)
    isLoading = false
    print("Data: \(data?.countries)\n")
  }
}

struct APIDataResource: APIResourceable {
  var path: String = "https://wwdc.community/api/staticdata"
  var method: HTTPMethod = .GET
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

