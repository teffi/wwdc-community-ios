//
//  ContentAltView.swift
//  CommunityWeek2023
//
//  Created by Steffi Tan on 5/31/23.
//

import SwiftUI
import Combine

struct ContentAltView: View {
  @State var data: CommunityData?
  @StateObject var viewModel = ContentAltModel()
  let network = Network()
  let resource = APIDataResource()
  
  
  var body: some View {
    VStack {
      if viewModel.countries.isEmpty {
        Text("No Data")
      } else {
        List {
          ForEach(viewModel.countries, id:\.country) { item in
            Section {
              ForEach(viewModel.getAllEvents(country: item.country)) { eventDetails in
                NavigationLink(value: eventDetails) {
                  CountryCityItem(cityText: eventDetails.cityLabel, numOfEvents: eventDetails.events.count)
                }
              }
            } header: {
              HStack {
                Text(item.flag)
                Text(item.countryLabel)
              }
            } // Section
          } // Foreach
        } // List
        .headerProminence(.increased)
        .navigationDestination(for: EventsPerCity.self) { cityData in
          CityEvents(cityData: cityData)
        }
      }
    }
    .onAppear {
//      loadData()
      print("on appear")
    }
  }
}

class ContentAltModel: ObservableObject {
  @Published var data: CommunityData = CommunityData(countries: [], events: [])
  @Published var countries: [Country] = []
  @Published var allEvents: [EventsPerCity] = []
  
  var subscriptions = [AnyCancellable]()
  
  init() {
    let network = Network()
    let resource = APIDataResource()
    let _ = network.sendRequestUsingCombine(api: resource, type: CommunityData.self)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure(let error):
          print("data error \(error)")
        case .finished:
          print("finished")
        }
      } receiveValue: { data in
        self.data = data
//        print("data \(data)")
      }
      .store(in: &subscriptions)
    
    
    //  Subscribe to data and assign data.coutries to countries
    $data
      .map(\.countries)
      .assign(to: &$countries)
    
    $data
      .map(\.events)
      .assign(to: &$allEvents)
  }
  
  func getAllEvents(country: String) -> [EventsPerCity] {
    return allEvents.filter { $0.country == country }
  }
  
  private func assigningData() {
    // To use, move code to init
    let network = Network()
    let resource = APIDataResource()
    network.sendRequestUsingCombine(api: resource, type: CommunityData.self)
      .map(\.countries)
      .replaceError(with: [])
      .receive(on: DispatchQueue.main)
      .assign(to: &$countries)
  }
  
  private func subscribingForData() {
    let network = Network()
    let resource = APIDataResource()
    let _ = network.sendRequestUsingCombine(api: resource, type: CommunityData.self)
      .receive(on: DispatchQueue.main)
      .sink { completion in
        switch completion {
        case .failure(let error):
          print("data error \(error)")
        case .finished:
          print("finished")
        }
      } receiveValue: { data in
        self.data = data
        print("data \(data)")
      }
      .store(in: &subscriptions)
  }
}

//
//struct ContentAltView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentAltView()
//    }
//}
