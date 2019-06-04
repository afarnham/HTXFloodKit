//
//  HarrisFWSService.swift
//  HTXFloodKit
//
//  Created by Raymond Farnham on 9/1/17.
//  Copyright © 2017 TinyRobot. All rights reserved.
//

import Foundation
import Prelude
import Tagged
import Logging
import Either
import Optics

public struct HarrisFWSService {
    public var fetchGauges: () -> EitherIO<Error, GaugeCollection>
    
    public init(fetchGauges: @escaping () -> EitherIO<Error, GaugeCollection>) {
        self.fetchGauges = fetchGauges
    }
}

extension HarrisFWSService {
    public init(logger: Logger?) {
        self.init(
            fetchGauges: { fetchGaugeCollection() |> runHarrisFWS(logger) }
        )
    }
}

private let harrisFWSJsonDecoder = JSONDecoder()

private func runHarrisFWS<A>(_ logger: Logger?) -> (DecodableRequest<A>) -> EitherIO<Error, A> {
  return { harrisFWSRequest in
    jsonDataTask(with: harrisFWSRequest.rawValue, decoder: harrisFWSJsonDecoder, logger: logger)
  }
}

func fwsBody(_ url: URL) -> Data? {
    let parameters = [
        "regionId" : "1",
        "timeSpan" : "7",
        "dt" : "\(Date().timeIntervalSince1970)"
    ]
    let queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
    var components = URLComponents(string: url.absoluteString)
    components?.queryItems = queryItems
        
    return components?.percentEncodedQuery?.data(using: .utf8)
}

private func fwsDataTask<A>(_ path: String) -> DecodableRequest<A> {
    let url = URL(string: "https://harriscountyfws.org" + path)!
    return DecodableRequest(
            rawValue: URLRequest(url: url)
            |> \.allHTTPHeaderFields .~ [
                "Content-Type" : "application/x-www-form-urlencoded; charset=UTF-8",
                "Referer" : "https://www.harriscountyfws.org/",
                "Accept" : "*/*",
                "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4",
                "Origin" : "https://www.harriscountyfws.org",
                "X-Requested-With" : "XMLHttpRequest"
                ]
            |> \.httpMethod .~ "POST"
            |> \.httpBody .~ fwsBody(url)
    )
}

func fetchGaugeCollection() -> DecodableRequest<GaugeCollection> {
    return fwsDataTask("/Home/GetSiteRecentData")
}

public class _HarrisFWSService {
    let recentDataPath = "https://www.harriscountyfws.org/Home/GetSiteRecentData"
    let sessionConfig = URLSessionConfiguration.default
    lazy var session: URLSession = {
        return URLSession(configuration: sessionConfig)
    }()
    
    var task: URLSessionDataTask? = nil
    
    public init() {}

    public func requestGaugeCollection(completion: @escaping (GaugeCollection?, Error?) -> Void) {
        guard let url = URL(string: recentDataPath) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = [
            "Content-Type" : "application/x-www-form-urlencoded; charset=UTF-8",
            "Referer" : "https://www.harriscountyfws.org/",
            "Accept" : "*/*",
            "User-Agent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4",
            "Origin" : "https://www.harriscountyfws.org",
            "X-Requested-With" : "XMLHttpRequest"
        ]
        
        let parameters = [
            "regionId" : "1",
            "timeSpan" : "7",
            "dt" : "\(Date().timeIntervalSince1970)"
        ]
        let queryItems = parameters.map {
            return URLQueryItem(name: $0, value: $1)
        }
        var components = URLComponents(string: recentDataPath)
        components?.queryItems = queryItems
        
        guard let query = components?.percentEncodedQuery else {
            return
        }
        request.httpBody = query.data(using: .utf8)
        task = session.dataTask(with: request) { (someData, someResponse, someError) in
            if let data = someData,
                let jsonStr = String.init(data: data, encoding: .utf8) {
                print(jsonStr)
                let decoder = JSONDecoder()
                let gaugeCollection = try! decoder.decode(GaugeCollection.self, from: data)
                completion(gaugeCollection, nil)
            }
        }
        task?.resume()
    }
    
    func currentGaugeCollectionReadings() -> GaugeCollection? {
        return nil
    }
}
