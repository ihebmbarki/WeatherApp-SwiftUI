//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Iheb Mbarki on 20/9/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isEditing = false
    @State private var showHourlyForecast = false  // State to toggle between daily and hourly

    var body: some View {
        ZStack {
            BackgroundView(isNight: .constant(false))  // Adjust as needed

            VStack {
                // City Search Field
                TextField("Search City", text: $viewModel.cityName, onEditingChanged: { editing in
                    isEditing = editing
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    viewModel.getWeather()  // Fetch weather when user finishes typing
                }

                // City Suggestions List
                if isEditing && !viewModel.suggestions.isEmpty {
                    List(viewModel.suggestions, id: \.self) { suggestion in
                        Button(action: {
                            viewModel.cityName = suggestion
                            isEditing = false
                            viewModel.getWeather()  // Fetch weather when city is selected
                       
                        }) {
                            Text(suggestion)
                        }
                    }
                    .frame(height: 150)  // Limit the height of the suggestions list
                }

                Spacer()  // Push everything to the top
                
//                // Toggle Button for Hourly Forecast
//                WeatherButton(
//                    title: showHourlyForecast ? "Show Daily Forecast" : "Show Hourly Forecast",
//                    textColor: .blue,
//                    backgroundColor: .white,
//                    action: {
//                        showHourlyForecast.toggle()  // Toggle between hourly and daily forecast
//                        if !showHourlyForecast {
//                            viewModel.getWeather() // Fetch weather again if switching back to daily
//                        }
//                    }
//                )

                // Weather View
                if let currentDayWeather = viewModel.weeklyWeather.first {
                    WeatherView(
                        imageName: viewModel.getWeatherIcon(for: currentDayWeather.condition),
                        temperature: Int(currentDayWeather.maxTemperature),
                        condition: currentDayWeather.condition  // Pass the condition here
                    )
                    .padding(.bottom, 20)
                    .frame(width: 250, height: 250)
                }

                // Horizontal Stack for the rest of the week's weather
                if viewModel.weeklyWeather.count > 1 {
                    HStack(spacing: 15) {
                        ForEach(viewModel.weeklyWeather.dropFirst(), id: \.dayOfWeek) { dayWeather in
                            WeatherDayView(dayOfWeek: dayWeather.dayOfWeekShort,
                                           imageName: viewModel.getWeatherIcon(for: dayWeather.condition),
                                           temperature: Int(dayWeather.maxTemperature))
                        }
                    }
                    .padding(.bottom, 20)  // Padding at the bottom of the screen
                }

                // Hourly Forecast View
                if showHourlyForecast, !viewModel.hourlyWeather.isEmpty {
                    ScrollView(.horizontal) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.hourlyWeather) { hourWeather in
                                WeatherHourView(hour: hourWeather.hour,
                                                imageName: viewModel.getWeatherIcon(for: hourWeather.condition),
                                                temperature: Int(hourWeather.temperature))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .frame(height: 100)
                }

                Spacer()  // Push everything to the center and bottom
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}



