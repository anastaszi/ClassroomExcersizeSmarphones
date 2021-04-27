//
//  LocationViewModel.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 4/26/21.
//

import Foundation
import CoreLocation
import MapKit

//CLLocationCoordinate2D is neither Codable nor Hashable. This means we can’t use a Core Location coordinate as key in a dictionary
struct Coordinate: Codable, Hashable {
    var latitude, longitude: Double
//    enum CodingKeys: String, CodingKey {
//            case latitude = "latitude"
//            case longitude = "longitude"
//        }
}

//It inherits from NSObject, since it will implement CLLocationManagerDelegate protocol for observing location changes.
class LocationViewModel: NSObject, ObservableObject{
  
    //@Published var userLatitude: Double = 0
    //@Published var userLongitude: Double = 0
    @Published var userLocation: Coordinate = Coordinate(latitude: 0, longitude: 0)
    @Published var location: CLLocation?
    @Published var placemark: CLPlacemark?
        //placemark?.name shows the street name
    @Published var status: CLAuthorizationStatus?
    
    @Published var mapModel = MapModel()
    @Published var isUpdating: Bool = false
//    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.335480, longitude: -121.893028), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//    @Published var points: [AnnotatedItem] = []
    
    private let geocoder = CLGeocoder()
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        //self.locationManager.startUpdatingLocation()
        self.mapModel.currentLocation = true
    }
    
    private func geocode() {
        guard let location = self.location else { return }
        geocoder.reverseGeocodeLocation(location, completionHandler: { (places, error) in
            if error == nil {
                self.placemark = places?[0]

            } else {
                self.placemark = nil
            }
        })
    }
    //typealias LocationNameResultType = Result<String, Error>
    func getCityName(completion: @escaping (Result<String, Error>) -> Void) {
        guard let location = location else {
            completion(.failure(LocationServiceErrors.locationNil))
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                completion(.failure(error))
            }
            //placemark.locality
            guard let placemark = placemarks?.first,
                  let cityName = placemark.name else {
                completion(.failure(LocationServiceErrors.placeMarkNil))
                return
            }
            
            completion(.success(cityName))
        }
    }
    
    func startLocationUpdate(){
        self.locationManager.startUpdatingLocation()
        self.isUpdating = true
    }
    
    func stopLocationUpdate(){
        self.locationManager.stopUpdatingLocation()
        self.isUpdating = false
    }
    
    func gohome(){
        self.mapModel.update(name: "current location", coordinate: userLocation)
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        //userLatitude = location.coordinate.latitude
        //userLongitude = location.coordinate.longitude
        self.userLocation.latitude = location.coordinate.latitude
        self.userLocation.longitude = location.coordinate.longitude
        self.location = location
        print(location)
        
        //self.mapmodel.update(name: "current location", coordinate: userlocation)
        
        self.geocode()
    }
}

enum LocationServiceErrors: LocalizedError {
    case userDeniedWhenInUseAuthorization
    case locationNil
    case placeMarkNil
    
    var errorDescription: String? {
        switch self {
        case .userDeniedWhenInUseAuthorization:
            return "You've denied location authorization"
            
        case .locationNil:
            return "Something goes wrong."
            
        case .placeMarkNil:
            return "Can't get location name"
        }
    }
}
