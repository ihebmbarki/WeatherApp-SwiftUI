//
//  WeatherViewModel.swift
//  SwiftUI-Weather
//
//  Created by Iheb Mbarki on 22/9/2024.
//

import Foundation
import MapKit
import Combine

class WeatherViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var cityName: String = ""
    @Published var weeklyWeather: [DailyWeatherData] = []
    @Published var hourlyWeather: [HourlyWeatherData] = []
    @Published var suggestions: [String] = []
    
    private let weatherManager = WeatherManager()
    private var completer = MKLocalSearchCompleter()
    private var cancellable: AnyCancellable?

    override init() {
        super.init()
        
        completer.resultTypes = .address
        completer.filterType = .locationsOnly
        completer.delegate = self
        
        cancellable = $cityName
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchTerm in
                self?.completer.queryFragment = searchTerm
            }
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.suggestions = completer.results.map { $0.title }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Failed to fetch autocomplete results: \(error.localizedDescription)")
    }

    func getWeather() {
        weatherManager.fetchWeather(for: cityName) { [weak self] result in
            // Ensure self is captured weakly to prevent retain cycles
            guard let self = self else { return }
            
            // Use DispatchQueue.main.async to update the UI
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherResponse):
                    self.weeklyWeather = self.processWeatherResponse(weatherResponse)
                    self.hourlyWeather = self.processHourlyWeatherResponse(weatherResponse)  // Process hourly weather
                case .failure(let error):
                    print("Failed to fetch weather: \(error.localizedDescription)")
                }
            }
        }
    }

    private func processWeatherResponse(_ weatherResponse: WeatherResponse) -> [DailyWeatherData] {
        return zip(zip(weatherResponse.daily.time, weatherResponse.daily.temperature_2m_max), weatherResponse.daily.weathercode)
            .map { (timeTempPair, weatherCode) in
                let (date, maxTemp) = timeTempPair
                let condition = self.getCondition(from: weatherCode)
                
                return DailyWeatherData(
                    dayOfWeek: self.getDayOfWeek(from: date),
                    maxTemperature: maxTemp,
                    dayOfWeekShort: String(self.getDayOfWeek(from: date).prefix(3)),
                    condition: condition
                )
            }
    }
    
    private func processHourlyWeatherResponse(_ weatherResponse: WeatherResponse) -> [HourlyWeatherData] {
        return weatherResponse.hourly.time.enumerated().map { index, time in
            let condition = self.getCondition(from: weatherResponse.hourly.weathercode[index])
            let temperature = weatherResponse.hourly.temperature_2m[index]
            return HourlyWeatherData(hour: time, temperature: temperature, condition: condition)
        }
    }

    func getCondition(from weatherCode: Int) -> String {
        switch weatherCode {
        case 0:
            return "clear"
        case 1...3:
            return "partly cloudy"
        case 45, 48:
            return "fog"
        case 51...53, 61...63, 80...81:
            return "rain"
        case 61:
            return "showers"
        case 71...73:
            return "snow"
        case 76, 77:
            return "snow showers"
        case 95...99:
            return "thunderstorm"
        default:
            return "unknown"
        }
    }

    func getDayOfWeek(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "E"
            return formatter.string(from: date)
        }
        return "N/A"
    }

    func getWeatherIcon(for condition: String) -> String {
        switch condition.lowercased() {
        case "clear":
            return "sun.max.fill"
        case "clouds":
            return "cloud.fill"
        case "rain":
            return "cloud.rain.fill"
        case "snow":
            return "cloud.snow.fill"
        case "thunderstorm":
            return "cloud.bolt.fill"
        case "drizzle":
            return "cloud.drizzle.fill"
        default:
            return "cloud.fill"
        }
    }
}
