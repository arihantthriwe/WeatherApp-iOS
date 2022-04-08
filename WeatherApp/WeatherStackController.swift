//
//  WeatherStackController.swift
//  WeatherApp
//
//  Created by Arihant Thriwe on 07/04/22.
//

import Foundation
private enum API{
    static let key = ""
}
final class WeatherStackController: WebServiceController{
    // http://api.weatherstack.com/current?access_key = YOUR_ACCESS_KEY& query = New York
    
    var weatherList: WeatherStackData?
    var fallbackService: WebServiceController?
    init(fallbackService: WebServiceController? = nil) {
        self.fallbackService = fallbackService
    } 
    func fetchWeatherDta(for city: String, completionHandler: @escaping (String?, WebServiceControllerError?) -> Void) {
        let endPoint = "http://api.weatherstack.com/current?access_key=\(API.key)&query=\(city)"
        guard let safeURLString = endPoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let endPointURL = URL(string: safeURLString) else{
            completionHandler(nil, WebServiceControllerError.invalidURL(endPoint))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: endPointURL){ (data, response, error) in
            guard error == nil else{
                if let fallbackService = self.fallbackService {
                    fallbackService.fetchWeatherDta(for: city, completionHandler: completionHandler)
                }else{
                    completionHandler(nil, WebServiceControllerError.forwarded(error!))
                }
                return
            }
            
            guard let responseData = data else{
                if let fallbackService = self.fallbackService {
                    fallbackService.fetchWeatherDta(for: city, completionHandler: completionHandler)
                }else{
                    completionHandler(nil, WebServiceControllerError.invalidPayload(endPointURL))
                }
                return
            }
            
            let decoder = JSONDecoder()
            do{
                print(responseData)
                self.weatherList = try decoder.decode(WeatherStackData.self, from: responseData)
                guard let weatherInfo = self.weatherList?.current.weatherDescriptions.first,
                      let temperature = self.weatherList?.current.temperature else{
                          completionHandler(nil, WebServiceControllerError.invalidPayload(endPointURL))
                          return
                      }
                let weatherDescription = "\(weatherInfo) \(temperature) °F"
                completionHandler(weatherDescription, nil)
            }catch let error{
                completionHandler(nil, WebServiceControllerError.forwarded(error))
            }
        }
        
        dataTask.resume()
    }
}
