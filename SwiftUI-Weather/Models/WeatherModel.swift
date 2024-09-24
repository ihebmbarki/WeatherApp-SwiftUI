//
//  WeatherModel.swift
//  SwiftUI-Weather
//
//  Created by Iheb Mbarki on 22/9/2024.
//

struct WeatherResponse: Codable {
    struct Daily: Codable {
        let time: [String]
        let temperature_2m_max: [Double]
        let temperature_2m_min: [Double]
        let weathercode: [Int]
    }
    
    struct Hourly: Codable {
        let time: [String]
        let temperature_2m: [Double]
        let weathercode: [Int]
        
    }

    let daily: Daily
    let hourly: Hourly 
}
