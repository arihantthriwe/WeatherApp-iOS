//
//  OpenWeatherMapController.swift
//  WeatherApp
//
//  Created by Arihant Thriwe on 07/04/22.
//

import Foundation

class APIKEY{
    var config: [String: Any]?
    public func getKey() -> String?{
        if let infoPlistPath = Bundle.main.url(forResource: "Keys", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    config = dict
                }
            } catch {
                return nil
            }
        }
        return config?["APIKey"] as! String?
    }
}
private enum API{
    static let key = ""
}

class OpenWeatherMapController: WebServiceController{
    // https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    // https://api.openweathermap.org/data/2.5/weather?q=London&appid={API key}
//    lazy var APIKey: String? = {
//        return APIKEY().getKey()
//    }()
//    lazy var endPoint = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(APIKey ?? "")"
    func fetchWeatherDta(for city: String, completionHandler: @escaping (String?, WebServiceControllerError?) -> Void) {
        let endPoint = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(API.key)"
        
        guard let safeURLString = endPoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let endPointURL = URL(string: safeURLString) else{
            completionHandler(nil, WebServiceControllerError.invalidURL(endPoint))
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: endPointURL){ (data, response, error) in
            guard error == nil else{
                completionHandler(nil, WebServiceControllerError.forwarded(error!))
                return
            }
            
            guard let responseData = data else{
                completionHandler(nil, WebServiceControllerError.invalidPayload(endPointURL))
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let weatherList = try decoder.decode(OpenWeatherMapContainer.self, from: responseData)
                guard let weatherInfo = weatherList.list?.first,
                      let weather = weatherInfo.weather.first?.main,
                      let temperature = weatherInfo.main.temp else{
                          completionHandler(nil, WebServiceControllerError.invalidPayload(endPointURL))
                          return
                      }
                let weatherDescription = "\(weather) \(temperature) F"
                completionHandler(weatherDescription, nil)
            }catch let error{
                completionHandler(nil, WebServiceControllerError.forwarded(error))
            }
        }
        
        dataTask.resume()
        
    }
    
    
}
