//
//  Text+Extension.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 18.05.2023.
//

import SwiftUI

extension Text {
    init(localizableKey:String) {
        self.init(LocalizedStringKey(localizableKey))
    }
}
