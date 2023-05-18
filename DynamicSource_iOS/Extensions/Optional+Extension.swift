//
//  Optional+Extension.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 18.05.2023.
//

import Foundation

extension Optional where Wrapped == String {
    func isOptional() -> String {
        return self ?? ""
    }
}
