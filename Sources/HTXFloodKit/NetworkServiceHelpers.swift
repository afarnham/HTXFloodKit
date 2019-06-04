import Foundation
import Logging
import Prelude
import Either
import Tagged
import Optics

typealias DecodableRequest<A> = Tagged<A, URLRequest> where A: Decodable

private let timeoutInterval: TimeInterval = 25

public func dataTask(
  with request: URLRequest,
  logger: Logger?
  )
  -> EitherIO<Error, (Data, URLResponse)> {
  return .init(
    run: .init { callback in

      let startTime = Date().timeIntervalSince1970
      let uuid = UUID().uuidString
      logger?.debug("[Data Task] \(uuid) \(request.url?.absoluteString ?? "nil") \(request.httpMethod ?? "UNKNOWN")")

      let session = URLSession.shared
      let request = request |> \.timeoutInterval .~ timeoutInterval
      session
        .dataTask(with: request) { data, response, error in
          let endTime = Date().timeIntervalSince1970
          let delta = Int((endTime - startTime) * 1000)

          let dataMsg = data.map { _ in "some" } ?? "none"
          let responseMsg = response.map { _ in "some" } ?? "none"
          let errorMsg = error.map(String.init(describing:)) ?? "none"

          logger?.debug("""
            [Data Task] \(uuid) \(delta)ms, \
            \(request.url?.absoluteString ?? "nil"), \
            (data, response, error) = \
            (\(dataMsg), \(responseMsg), \(errorMsg))
            """
          )

          if let error = error {
            callback(.left(error))
            return
          }
          if let data = data, let response = response {
            callback(.right((data, response)))
            return
          }
        }
        .resume()
    }
  )
}

public func logError<A>(
  subject: String,
  logger: Logger,
  file: StaticString = #file,
  line: UInt = #line
  ) -> (Error) -> EitherIO<Error, A> {

  return { error in
    var errorDump = ""
    dump(error, to: &errorDump)
    logger.error("\(errorDump)")

    return throwE(error)
  }
}

public enum JSONError: Error {
  case error(String, Error)
}

public func jsonDataTask<A>(
  with request: URLRequest,
  decoder: JSONDecoder? = nil,
  logger: Logger?
  )
  -> EitherIO<Error, A>
  where A: Decodable {

    return dataTask(with: request, logger: logger)
      .map(first)
      .flatMap { data in
        .wrap {
          do {
            return try (decoder ?? defaultDecoder).decode(A.self, from: data)
          } catch {
            throw JSONError.error(String(decoding: data, as: UTF8.self), error)
          }
        }
    }
}

private let defaultDecoder = JSONDecoder()
