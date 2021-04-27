//
//  CurrentLocationMapView.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/27/21.
//

import SwiftUI

struct CurrentLocationMapView: View {
    @StateObject var locationViewModel = LocationViewModel()
    var body: some View {
        VStack {
            MapView(mapModel: locationViewModel.mapModel)
            Text("Location updating \(locationViewModel.isUpdating.description)")
            Text("Current place: \(locationViewModel.placemark?.description ?? "")")
            HStack {
                Button("Start Location") {
                    locationViewModel.startLocationUpdate()
                }
                Button("Stop Location") {
                    locationViewModel.stopLocationUpdate()
                }
                Button("Go Home") {
                    locationViewModel.gohome()
                }
            }
        }
    }
}

struct CurrentLocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationMapView()
    }
}
