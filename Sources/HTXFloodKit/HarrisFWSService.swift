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
import HouFloodModel

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

private func fwsDataTask<A>() -> DecodableRequest<A> {
    let url = URL(string: "https://www.harriscountyfws.org/Home/GetSiteRecentData?timeSpan=7&regionId=1&dt=\(Date().timeIntervalSince1970)")!
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
    )
}

func fetchGaugeCollection() -> DecodableRequest<GaugeCollection> {
    return fwsDataTask()
}
