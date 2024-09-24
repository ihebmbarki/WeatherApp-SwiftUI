//
//  WeatherManager.swift
//  SwiftUI-Weather
//
//  Created by Iheb Mbarki on 22/9/2024.
//

import Foundation
import CoreLocation

enum ForecastType {
    case daily
    case hourly
}

class WeatherManager {
    let geocoder = CLGeocoder()
    
    func fetchWeather(for cityName: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        geocodeCity(cityName) { result in
            switch result {
            case .success(let coordinates):
                let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(coordinates.latitude)&longitude=\(coordinates.longitude)&daily=temperature_2m_max&daily=temperature_2m_min&daily=weathercode&hourly=temperature_2m,weathercode&timezone=auto"
                
                guard let url = URL(string: urlString) else {
                    print("Invalid URL")
                    return
                }
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let data = data else {
                        print("No data returned")
                        return
                    }
                    
                    do {
                        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                        completion(.success(weatherResponse))
                    } catch let jsonError {
                        completion(.failure(jsonError))
                    }
                }.resume()
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    private func geocodeCity(_ cityName: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        geocoder.geocodeAddressString(cityName) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let location = placemarks?.first?.location {
                completion(.success(location.coordinate))
            } else {
                completion(.failure(NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Location not found"])))
            }
        }
    }
}
