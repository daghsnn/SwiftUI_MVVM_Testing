//
//  Localization.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 19.05.2023.
//
import Foundation

enum LocalizeTexts: String {
    case pathNotFound = "pathNotFound"
    case coordinatsWrong = "coordinatsWrong"
    static func makeLocalize(_ text:LocalizeTexts) -> String {
        return NSLocalizedString(text.rawValue, tableName: "Localizable", bundle: Bundle.main, value: "", comment: "")
    }
}
