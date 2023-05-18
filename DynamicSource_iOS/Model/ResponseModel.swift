//
//  ResponseModel.swift
//  DynamicSource_iOS
//
//  Created by Hasan Dag on 16.05.2023.
//
import Foundation

// MARK: - Welcome
struct ResponseModel: Codable {
    let epwa: Epwa?

    enum CodingKeys: String, CodingKey {
        case epwa = "EPWA"
    }
}

// MARK: - Epwa
struct Epwa: Codable {
    let city, comments, country: String?
    let elev, elevation: Int?
    let iata, icao: String?
    let index: Int?
    let lastupdate, latitude, longitude, magneticvariation: String?
    let name: String?
    let rwy: Rwy?
    let state: String?

    enum CodingKeys: String, CodingKey {
        case city = "CITY"
        case comments = "COMMENTS"
        case country = "COUNTRY"
        case elev = "ELEV"
        case elevation = "ELEVATION"
        case iata = "IATA"
        case icao = "ICAO"
        case index = "INDEX"
        case lastupdate = "LASTUPDATE"
        case latitude = "LATITUDE"
        case longitude = "LONGITUDE"
        case magneticvariation = "MAGNETICVARIATION"
        case name = "NAME"
        case rwy = "RWY"
        case state = "STATE"
    }
}

// MARK: - Rwy
struct Rwy: Codable {
    let the11: The11?

    enum CodingKeys: String, CodingKey {
        case the11 = "11"
    }
}

// MARK: - The11
struct The11: Codable {
    let alignmenttype, approachslope: String?
    let asda, clearway: Int?
    let comments, designator: String?
    let distanceUnit, elev, elevEnd, elevThr: Int?
    let engfail, entryangle, extraident: String?
    let fullorintersection: Int?
    let hdg: String?
    let heightUnit: Int?
    let ident: String?
    let index: Int?
    let lastupdate: String?
    let lda: Int?
    let ldcomments, magneticheading, magneticheadingdate: String?
    let maxlength: Int?
    let name: String?
    let obstacles: [Obstacle]?
    let position, rwyno: String?
    let shiftbeginning, shiftend: Int?
    let shoulder, slope: String?
    let stopway: Int?
    let strength: String?
    let takeoffshift: Int?
    let tempident: String?
    let thresholdelevation: Int?
    let thresholdlatitude, thresholdlongitude, tocomments: String?
    let toda, tora, width: Int?

    enum CodingKeys: String, CodingKey {
        case alignmenttype = "ALIGNMENTTYPE"
        case approachslope = "APPROACHSLOPE"
        case asda = "ASDA"
        case clearway = "CLEARWAY"
        case comments = "COMMENTS"
        case designator = "DESIGNATOR"
        case distanceUnit = "DISTANCE_UNIT"
        case elev = "ELEV"
        case elevEnd = "ELEV_END"
        case elevThr = "ELEV_THR"
        case engfail = "ENGFAIL"
        case entryangle = "ENTRYANGLE"
        case extraident = "EXTRAIDENT"
        case fullorintersection = "FULLORINTERSECTION"
        case hdg = "HDG"
        case heightUnit = "HEIGHT_UNIT"
        case ident = "IDENT"
        case index = "INDEX"
        case lastupdate = "LASTUPDATE"
        case lda = "LDA"
        case ldcomments = "LDCOMMENTS"
        case magneticheading = "MAGNETICHEADING"
        case magneticheadingdate = "MAGNETICHEADINGDATE"
        case maxlength = "MAXLENGTH"
        case name = "NAME"
        case obstacles = "OBSTACLES"
        case position = "POSITION"
        case rwyno = "RWYNO"
        case shiftbeginning = "SHIFTBEGINNING"
        case shiftend = "SHIFTEND"
        case shoulder = "SHOULDER"
        case slope = "SLOPE"
        case stopway = "STOPWAY"
        case strength = "STRENGTH"
        case takeoffshift = "TAKEOFFSHIFT"
        case tempident = "TEMPIDENT"
        case thresholdelevation = "THRESHOLDELEVATION"
        case thresholdlatitude = "THRESHOLDLATITUDE"
        case thresholdlongitude = "THRESHOLDLONGITUDE"
        case tocomments = "TOCOMMENTS"
        case toda = "TODA"
        case tora = "TORA"
        case width = "WIDTH"
    }
}

// MARK: - Obstacle
struct Obstacle: Codable {
    let distance: String?
    let elevation: Int?
    let lateraldistance, nature: String?
    let obstacledistance, obstacledistanceBr, obstacleelevation, obstacleelevationBr: Int?

    enum CodingKeys: String, CodingKey {
        case distance = "DISTANCE"
        case elevation = "ELEVATION"
        case lateraldistance = "LATERALDISTANCE"
        case nature = "NATURE"
        case obstacledistance = "OBSTACLEDISTANCE"
        case obstacledistanceBr = "OBSTACLEDISTANCE_BR"
        case obstacleelevation = "OBSTACLEELEVATION"
        case obstacleelevationBr = "OBSTACLEELEVATION_BR"
    }
}
