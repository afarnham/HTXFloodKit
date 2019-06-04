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
                        
                        logger?.debug("[Data Task] \(request.curlString)")
                        
                        
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


extension URLRequest {
    
    /**
     Returns a cURL command representation of this URL request.
     */
    public var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = "curl \(url.absoluteString)"
        
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }
        
        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }
        
        return command.joined(separator: " \\\n\t")
    }
    
    init?(curlString: String) {
        return nil
    }
    
}
