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
              HStack {
                Text(item.flag)
                Text(item.country)
              }
            }
          }
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
    print("Data: \(data?.countries)")
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

