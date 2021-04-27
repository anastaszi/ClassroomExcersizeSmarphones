//
//  MapModel.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/26/21.
//

import Foundation

import MapKit

struct AnnontatedItem: Identifiable {
    let id = UUID()
    var name: String
    var coordinate: CLLocationCoordinate2D
}

class MapModel: ObservableObject {
    @Published var region: MKCoordinateRegion
    @Published var points: [AnnontatedItem] = []
    
    var currentLocation: Bool = false;
    
    static var pointsOfInterest = [
        AnnontatedItem(name: "Times Square", coordinate: .init(latitude: 40.75773, longitude: -73.987508))
    ]
    
    init(name: String? = "", coordinate: Coordinate? = testCoordinate) {
        let regionCoordinate = coordinate ?? MapModel.testCoordinate
        
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: regionCoordinate.latitude, longitude: regionCoordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        self.points.append(AnnontatedItem(name: name ?? "", coordinate: .init(latitude: regionCoordinate.latitude, longitude: regionCoordinate.longitude)))
    }
    
    func update(name: String? = "", coordinate: Coordinate? ) {
        let regionCoordinates = coordinate ?? MapModel.testCoordinate
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: regionCoordinates.latitude, longitude: regionCoordinates.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.points = [AnnontatedItem(name: name ?? "", coordinate: .init(latitude: regionCoordinates.latitude, longitude: regionCoordinates.longitude))]
        
    }
    
    static let testRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.335480, longitude: -121.893028), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    static let testCoordinate = Coordinate(latitude: 37.335480, longitude: -121.893028)
}
