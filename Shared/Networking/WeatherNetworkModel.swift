//
//  WeatherNetworkModel.swift
//  ClassRoomExcersize (iOS)
//
//  Created by Anastasia Zimina on 5/16/21.
//

import Foundation
import Combine
import CoreLocation

class WeatherNetworkModel: ObservableObject {
    @Published var city: String = ""
    @Published var weather: String = ""
    @Published var weatherResponse: OneWeatherAPIResponse?
    @Published var activityshouldAnimate = false//false
    
    private let locationManager = CLLocationManager()
    private lazy var location: CLLocation? = locationManager.location
    
    static var weatherJSONDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .secondsSince1970
        return jsonDecoder
    }()
    
    private var bag = Set<AnyCancellable>()
    
    private let session: URLSession
    
    init(session: URLSession = .shared,//The shared singleton session object. For basic requests, the URLSession class provides a shared singleton session object that gives you a reasonable default behavior for creating tasks.
         scheduler: DispatchQueue = DispatchQueue(label: "WeatherNetworkModel"))
    {
        self.session = session
        
        //search city textfield
        $city
            .dropFirst(1) //As soon as you create the observation, $city emits its first value. Since the first value is an empty string, you need to skip it to avoid an unintended network call.
            .debounce(for: .seconds(1), scheduler: scheduler) //debounce works by waiting a second until the user stops typing
            .removeDuplicates()
            .filter{ $0.count >= 1 }
            .sink(receiveValue: requestCurrentWeather(queryCity:)) //You observe these events via sink(receiveValue:) and handle them with requestCurrentWeather(querycity:)
            .store(in: &bag)
    }
    

    func getWeather(queryCity: String) {
        //let city = "Atlanta"
        let weatherURL = makeCurrentDayForecastComponents(withCity: self.city).url!
        
        let task = self.session.dataTask(with: weatherURL) { data, response, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                fatalError("Error: Invalid HTTP respnce code")
            }
            
            guard let data = data else {
                fatalError("Error: missing response data")
            }
            
            do {
                let decoder = JSONDecoder()
                let posts = try decoder.decode(CurrentWeatherForecastResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.weather = "Temperature \(posts.main.temperature)"
                    print(self.weather)
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }
    
    func getWeatherCombine(queryCity: String) -> AnyPublisher<Data, Error> {
        let weatherURL = makeCurrentDayForecastComponents(withCity: queryCity).url!
        let urlRequest = URLRequest(url: weatherURL, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError({error -> Error in
                APIErrors(rawValue: error.code.rawValue) ?? APIProviderErrors.unknownError
            })
            .map {
                $0.data
            }
            .eraseToAnyPublisher()
    }
    
    func getWeatherCombine(location: Coordinate) -> AnyPublisher<Data, Error> {
        
        let weatherURL = makeOneCallAPIComponents(coordinate: location).url!
        let urlRequest = URLRequest(url: weatherURL, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 30)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError({error -> Error in
                APIErrors(rawValue: error.code.rawValue) ?? APIProviderErrors.unknownError
            })
            .map {
                $0.data
            }
            .eraseToAnyPublisher()
    }
    
    
    func requestCurrentWeather(queryCity: String) {
        DispatchQueue.main.async {
                    // update ui here
                    self.activityshouldAnimate = true
                }
        return self.getWeatherCombine(queryCity: queryCity)
            .decode(type: CurrentWeatherForecastResponse.self, decoder: WeatherNetworkModel.weatherJSONDecoder)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[weak self] value in
                print("receivedCompletion")
                guard let self = self else { return }
                switch value {
                    case .failure:
                                            self.weather = "Not available"
                                            self.activityshouldAnimate = false
                    case .finished:
                                            self.activityshouldAnimate = false
                                            break
            }
            },
            receiveValue: { [weak self] weather in
                print(weather)
                self?.weather = "Temperature \(weather.main.temperature) and \(weather.main.humidity)"
            })
            .store(in: &bag)
    }
    
    func requestCurrentLocationWeatherCombine() -> AnyPublisher<Data, Error> {
        locationManager.requestWhenInUseAuthorization()
        
        guard CLLocationManager.locationServicesEnabled() else {
            return Fail(error: WeatherServiceErrors.userDeniedWhenInUseAuthorization)
                .eraseToAnyPublisher()
        }
            
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        guard let location = location else {
            return Fail(error: WeatherServiceErrors.locationNil)
                .eraseToAnyPublisher()
        }
        
        return self.getWeatherCombine(location: Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            .eraseToAnyPublisher()
    }
    
    func requestCurrentLocationWeather() {
        return self.requestCurrentLocationWeatherCombine()
                            .decode(type: OneWeatherAPIResponse.self, decoder: WeatherNetworkModel.weatherJSONDecoder)
                            .receive(on: RunLoop.main)
                            .sink(
                                receiveCompletion: { _ in //[weak self]
                                    //self?.weather = "receiveCompletion"
                                    print("receiveCompletion")
                                },
                                receiveValue: { [weak self] weather in
                                    //self?.weather = "Temperature \(posts.main.temperature)°C Humidity \(posts.main.humidity)% ."//weather
                                    print(weather)
                                    //self?.weather = "Temperature \(weather.current.temperature)°C Humidity \(weather.current.humidity)% ."
                                    self?.weatherResponse = weather
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateStyle = .medium
                                    dateFormatter.timeStyle = .none
                                    dateFormatter.locale = Locale(identifier: "en_US")
                                    let datastr=dateFormatter.string(from: weather.current.currenttime) // Jan 2, 2001
                                    self?.weather = "Temperature \(weather.current.temperature)°C Humidity \(weather.current.humidity)% \(weather.current.weather[0].main) \(datastr)."
                                }
                            )
                            .store(in: &bag)
            }
}

private extension WeatherNetworkModel {
    struct OpenWeatherAPI {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let key = "2b492c001d57cd5499947bd3d3f9c47b"//<your key>"
    }
    
    func makeWeeklyForecastComponents(
        withCity city: String
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/forecast"
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
        ]
        
        return components
    }
    
    func makeCurrentDayForecastComponents(
        withCity city: String
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/weather"
        
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
        ]
        
        return components
    }
    
    //https://openweathermap.org/api/one-call-api
    func makeOneCallAPIComponents(
        coordinate: Coordinate
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/onecall"
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(format: "%.6f", coordinate.latitude)),
            URLQueryItem(name: "lon", value: String(format: "%.6f", coordinate.longitude)),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
        ]
        
        return components
    }
}
