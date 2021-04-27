//
//  MapView.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/26/21.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var mapModel: MapModel
    
    var body: some View {
        if mapModel.currentLocation == true {
            Map(coordinateRegion: $mapModel.region, showsUserLocation: true, userTrackingMode: .constant(.follow))
        }
        else {
            Map(coordinateRegion: $mapModel.region, annotationItems: mapModel.points) {
                        item in
                        MapMarker(coordinate: item.coordinate, tint: .red)
                    }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mapModel: MapModel(coordinate: Coordinate(latitude: 40.75773, longitude: -73.985708)))
    }
}
