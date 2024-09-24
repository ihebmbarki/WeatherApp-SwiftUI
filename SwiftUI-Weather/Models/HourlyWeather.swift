//
//  HourlyWeather.swift
//  SwiftUI-Weather
//
//  Created by Iheb Mbarki on 24/9/2024.
//

import Foundation

struct HourlyWeatherData: Identifiable {
    let id = UUID()
    let hour: String
    let temperature: Double
    let condition: String
}
