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
        print(config?["APIKey"] as! String)
        return config?["APIKey"] as! String?
    }
}

class OpenWeatherMapController: WebServiceController{
    // https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    // https://api.openweathermap.org/data/2.5/weather?q=London&appid={API key}
    lazy var APIKey: String? = {
        return APIKEY().getKey()
    }()
    let endPoint = "https://api.openweathermap.org/data/2.5/weather?q=\("city")&appid="
    func fetchWeatherDta(for city: String, completionHandler: (String?, WebServiceControllerError?) -> Void) {
    }
    
    
}
