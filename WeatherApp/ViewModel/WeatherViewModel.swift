//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Arihant Thriwe on 07/04/22.
//

import Foundation

class WeatherViewModel: ObservableObject{
    private let weatherService = OpenWeatherMapController(fallbackService: WeatherStackController())
    @Published var weatherInfo = ""
    func fetch(city: String){
        weatherService.fetchWeatherDta(for: city){ (info, error) in
            guard error == nil,
                  let weatherInfo = info else{
                      DispatchQueue.main.async {
                        self.weatherInfo = "Could not retrieve weather information for \(city)\(error)"
                      }
                      return
                  }
            DispatchQueue.main.async {
                self.weatherInfo = weatherInfo
            }
        }
    }
}
