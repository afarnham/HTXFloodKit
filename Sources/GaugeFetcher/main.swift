import Foundation
import Prelude
import Either
import HTXFloodKit
import Logging

#if os(Linux)
let path = "/home/fwsserver/website/data/fws.json"
#else
let path = "/Users/aaron/fws.json"
#endif

func encode<T: Encodable>(_ encodable: T) -> Either<Error, Data> {
	let encoder = JSONEncoder()
	do {
		return .right(try encoder.encode(encodable))
	} catch {
		return .left(error)
	}
}

func fetchGaugeInfo(completion: @escaping () -> Void) {
 	var logger = Logger(label: "com.tinyrobot.org.fws")
    logger.logLevel = .debug
     let service = HarrisFWSService(logger: logger)
     let fileService = FileService(logger: logger)
    
    let url = URL(fileURLWithPath:path)
    service
        .fetchGauges()
        .map(encode)
        .flatMap { (data) -> EitherIO<Error, Prelude.Unit> in
            switch data {
            case .left(let error):
                return lift(.left(error))
            case .right(let d):
                return fileService.save(url, d)
            }
        }
        .run
        .parallel
        .run { (result) in
            print(result)
            completion()
        }
}

func main() {
	fetchGaugeInfo { exit(0) }
    dispatchMain()
}

main()
