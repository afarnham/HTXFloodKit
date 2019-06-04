//
//  GageCollection.swift
//  HTXFloodKit
//
//  Created by Raymond Farnham on 9/1/17.
//  Copyright © 2017 TinyRobot. All rights reserved.
//

import Foundation

public struct GageCollectionDataRange: Codable {
    let StartDate: String?
    let EndDate: String
}

public struct GageCollectionProperties: Codable {
    let DataRange: GageCollectionDataRange
}

public struct GageCollection: Codable {
    let type: String
    let properties: GageCollectionProperties
    let features: [GageFeature]
}

public struct GageGeometry: Codable {
    let type: String
    let coordinates: [Double]
    let offset: [Double]
    let Text: String
}

public struct GagePropertyStreamDataChannelInfo: Codable {
    let TOB: Double?
    let BOC: Double?
    let SensorId: Int
    let FloodStage: Bool?
    let FloodLevelIndicator: Double?
    let NoFloodCategory: Bool
}

public struct GagePropertyStreamData: Codable {
    let CurrentLevel: Double
    let CurrentReadingDate: String
    let ChannelInfo: GagePropertyStreamDataChannelInfo
}

public struct GageProperties: Codable {
    let SiteId: Int
    let SiteType: String
    let Rainfall: Double
    let RainfallText: String
    let Description: String
    let StreamData: [GagePropertyStreamData]?
}
    
public struct GageFeature: Codable {
    let type: String
    let geometry: GageGeometry
    let properties: GageProperties
}
