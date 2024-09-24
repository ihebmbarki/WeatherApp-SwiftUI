//
//  WeatherDayView.swift
//  SwiftUI-Weather
//
//  Created by Iheb Mbarki on 23/9/2024.
//


import SwiftUI

struct WeatherDayView: View {
    var dayOfWeek: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack {
            Text(dayOfWeek)  // Use short day names like Mon, Tue, etc.
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            Image(systemName: imageName)  // Dynamically update weather icons
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            
            Text("\(temperature)°")
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.white)
        }
    }
}