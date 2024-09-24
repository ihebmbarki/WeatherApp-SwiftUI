//
//  WeatherView.swift
//  SwiftUI-Weather
//
//  Created by Iheb Mbarki on 23/9/2024.
//
import SwiftUI

struct WeatherView: View {
    var imageName: String
    var temperature: Int
    var condition: String  // New property for weather condition
    
    var body: some View {
        VStack(spacing: 8) {
            Text(condition.capitalized)  // Display the weather condition
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.white)
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)  // Larger size for WeatherView
            
            Text("\(temperature)°")
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}
