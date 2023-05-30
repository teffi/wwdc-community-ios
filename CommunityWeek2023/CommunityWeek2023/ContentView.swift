//
//  ContentView.swift
//  CommunityWeek2023
//
//  Created by Steffi Tan on 5/26/23.
//

import SwiftUI

// TODO:  Add loading state view wrapper?

struct ContentView: View {
  @State var isLoading = false
  @State var data: CommunityData?
  @State var errorText: String?
  
    var body: some View {
      ZStack {
        if isLoading {
          VStack {
            Text("Loading data")
          }
        } else if let err = errorText {
          VStack {
            Text(err)
          }
        } else {
          List {
            ForEach(data?.countries ?? [], id:\.country) { item in
              Section {
                ForEach(data?.events.filter { $0.country == item.country } ?? []) { eventDetails in
                  CountryCityItem(cityText: eventDetails.cityLabel, numOfEvents: eventDetails.events.count)
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
    do {
      data = try await network.sendRequestUsingAsyncAwait(api: resource)
      errorText = nil
      print("[Send] Load data")
    } catch let requestError as RequestError {
      print("[Received] Load data error: \(requestError)")
      errorText = requestError.message
   
    } catch _ {
      print("[Received] Load data error: unhandled issue")
      errorText = "Failed to send request"
    }
    
    isLoading = false
  
    print("Data: \(data?.countries)\n")
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct APIDataResource: APIResourceable {
  var path: String = "https://wwdc.community/api/staticdata"
  var method: HTTPMethod = .GET
}

struct CountryCityItem: View {
  let cityText: String
  let numOfEvents: Int
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text(cityText)
        .font(.headline)
      Text("\(numOfEvents) events")
        .opacity(0.7)
        .font(.system(size: 14))
        .padding(0)
    }.padding()
  }
}


