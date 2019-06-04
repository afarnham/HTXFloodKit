//
//  GaugeCollection.swift
//  HTXFloodKit
//
//  Created by Raymond Farnham on 9/1/17.
//  Copyright © 2017 TinyRobot. All rights reserved.
//

import Foundation

public struct GaugeCollectionDataRange: Codable {
    public let StartDate: String?
    public let EndDate: String
}

public struct GaugeCollectionProperties: Codable {
    public let DataRange: GaugeCollectionDataRange
}

public struct GaugeCollection: Codable {
    public let type: String
    public let properties: GaugeCollectionProperties
    public let features: [GaugeFeature]
}

public struct GaugeGeometry: Codable {
    public let type: String
    public let coordinates: [Double]
    public let offset: [Double]
    public let Text: String
}

public struct GaugePropertyStreamDataChannelInfo: Codable {
    public let TOB: Double?
    public let BOC: Double?
    public let SensorId: Int
    public let FloodStage: Bool?
    public let FloodLevelIndicator: Double?
    public let NoFloodCategory: Bool
}

public struct GaugePropertyStreamData: Codable {
    public let CurrentLevel: Double
    public let CurrentReadingDate: String
    public let ChannelInfo: GaugePropertyStreamDataChannelInfo
}

public struct GaugeProperties: Codable {
    public let SiteId: Int
    public let SiteType: String
    public let Rainfall: Double
    public let RainfallText: String
    public let Description: String
    public let StreamData: [GaugePropertyStreamData]?
}
    
public struct GaugeFeature: Codable {
    public let type: String
    public let geometry: GaugeGeometry
    public let properties: GaugeProperties
}
