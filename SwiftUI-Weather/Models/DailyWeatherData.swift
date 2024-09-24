//
//  DailyWeatherData.swift
//  SwiftUI-Weather
//
//  Created by Iheb Mbarki on 23/9/2024.
//
import Foundation

struct DailyWeatherData: Identifiable {
    let id = UUID()
    let dayOfWeek: String
    let maxTemperature: Double
    let dayOfWeekShort: String
    let condition: String
}
