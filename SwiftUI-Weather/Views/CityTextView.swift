//
//  CityTextView.swift
//  SwiftUI-Weather
//
//  Created by Iheb Mbarki on 23/9/2024.
//
import SwiftUI

struct CityTextView: View {
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium))
            .foregroundColor(.white)
            .padding()
    }
}
