//
//  WeatherButton.swift
//  SwiftUI-Weather
//
//  Created by Iheb Mbarki on 20/9/2024.
//

import SwiftUI

struct WeatherButton: View {
    var title: String
    var textColor: Color
    var backgroundColor: Color
    var action: () -> Void  // Add action parameter

    var body: some View {
        Button(action: action) {  // Use Button with action
            Text(title)
                .frame(width: 280, height: 50)
                .background(backgroundColor)
                .foregroundColor(textColor)
                .font(.system(size: 20, weight: .bold, design: .default))
                .cornerRadius(10)
        }
    }
}
