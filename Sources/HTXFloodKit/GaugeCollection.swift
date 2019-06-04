//
//  GaugeCollection.swift
//  HTXFloodKit
//
//  Created by Raymond Farnham on 9/1/17.
//  Copyright © 2017 TinyRobot. All rights reserved.
//

import Foundation

public struct GaugeCollectionDataRange: Codable {
    let StartDate: String?
    let EndDate: String
}

public struct GaugeCollectionProperties: Codable {
    let DataRange: GaugeCollectionDataRange
}

public struct GaugeCollection: Codable {
    let type: String
    let properties: GaugeCollectionProperties
    let features: [GaugeFeature]
}

public struct GaugeGeometry: Codable {
    let type: String
    let coordinates: [Double]
    let offset: [Double]
    let Text: String
}

public struct GaugePropertyStreamDataChannelInfo: Codable {
    let TOB: Double?
    let BOC: Double?
    let SensorId: Int
    let FloodStage: Bool?
    let FloodLevelIndicator: Double?
    let NoFloodCategory: Bool
}

public struct GaugePropertyStreamData: Codable {
    let CurrentLevel: Double
    let CurrentReadingDate: String
    let ChannelInfo: GaugePropertyStreamDataChannelInfo
}

public struct GaugeProperties: Codable {
    let SiteId: Int
    let SiteType: String
    let Rainfall: Double
    let RainfallText: String
    let Description: String
    let StreamData: [GaugePropertyStreamData]?
}
    
public struct GaugeFeature: Codable {
    let type: String
    let geometry: GaugeGeometry
    let properties: GaugeProperties
}
