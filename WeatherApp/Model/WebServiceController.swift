//
//  WebServiceController.swift
//  WeatherApp
//
//  Created by Arihant Thriwe on 07/04/22.
//

import Foundation

public enum WebServiceControllerError: Error{
    case invalidURL(String)
    case invalidPayload(URL)
    case forwarded(Error)
}

public protocol WebServiceController{
    func fetchWeatherDta(for city: String, completionHandler: (String?, WebServiceControllerError?) -> Void)
}
