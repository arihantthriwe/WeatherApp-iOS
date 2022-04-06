//
//  ContentView.swift
//  WeatherApp
//
//  Created by Arihant Thriwe on 07/04/22.
//

import SwiftUI

struct ContentView: View {
    @State private var input: String = ""
    var body: some View {
        VStack {
            TextField("Enter City to view it's Weather", text: $input)
                .font(.title)
            Divider()
            Text(input)
                .font(.body)
        }.padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
