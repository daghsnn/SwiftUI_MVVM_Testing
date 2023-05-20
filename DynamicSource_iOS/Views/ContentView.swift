//
//  ContentView.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 16.05.2023.
//

import SwiftUI

struct ContentView: View {
        
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "appThemeColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "textColor")]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "textColor")]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            MapView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
