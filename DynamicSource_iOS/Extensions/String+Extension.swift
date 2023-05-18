//
//  String+Extension.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 18.05.2023.
//

import Foundation

extension String {
    func isEmptyOrNil() -> Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
