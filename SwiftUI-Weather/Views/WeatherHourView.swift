//
//  WeatherHourView.swift
//  SwiftUI-Weather
//
//  Created by Iheb Mbarki on 24/9/2024.
//


import SwiftUI

struct WeatherHourView: View {
    var hour: String
    var imageName: String
    var temperature: Int

    var body: some View {
        VStack {
            Text(hour)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)

            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)

            Text("\(temperature)°")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(width: 70)
    }
}