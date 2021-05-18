//
//  CurrentLocationMapView.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/27/21.
//

import SwiftUI

struct CurrentLocationMapView: View {
    @StateObject var locationViewModel = LocationViewModel()
    
    @StateObject var weatherNetworkModel = WeatherNetworkModel()
    
    
    var body: some View {
        VStack {
            MapView(mapModel: locationViewModel.mapModel)
            Text("Location updating \(locationViewModel.isUpdating.description)")
            Text("Current place: \(locationViewModel.placemark?.description ?? "")")
            Text("Current weather: \(weatherNetworkModel.weather)").padding()
            HStack {
                Button("Start Location") {
                    locationViewModel.startLocationUpdate()
                    locationViewModel.getCityName(completion: {result in
                        switch result {
                        case let .success(locationName):
                            print(locationName)
                        case .failure:
                            print("Did not the city name")
                        }
                    })
                    //weatherNetworkModel.getWeather(queryCity: locationViewModel.placemark?.name ?? "San Jose,CA")
                    //weatherNetworkModel.requestCurrentWeather(queryCity: "Atlanta,US")
                    weatherNetworkModel.requestCurrentLocationWeather()
                }
                Button("Stop Location") {
                    locationViewModel.stopLocationUpdate()
                }
                Button("Go Home") {
                    locationViewModel.gohome()
                }
            }
            VStack{
                            HStack{
                                Text("Search Weather")
                                
                                ZStack{
                                    TextField("Search other cities, e.g. Cupertino", text: $weatherNetworkModel.city, onEditingChanged: { (changed) in
                                        print("City onEditingChanged - \(changed)")
                                        //gets called when user taps on the TextField or taps return. The changed value is set to true when user taps on the TextField and it’s set to false when user taps return.
                                    }) {
                                        //The onCommit callback gets called when user taps return.
                                        print("City onCommit")
                                        //self.viewModel.fetchWeather(forCity: self.viewModel.city)
                                    }
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    ActivityIndicator(shouldAnimate: $weatherNetworkModel.activityshouldAnimate)
                                }
                            }
                            //Display current weather for the searched city
                            Text("The weather for City \(weatherNetworkModel.city) is \(weatherNetworkModel.weather)").padding()
                        }
        }
    }
}

struct CurrentLocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationMapView()
    }
}
