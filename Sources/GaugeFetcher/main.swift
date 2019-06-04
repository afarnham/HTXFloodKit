import Foundation
import Prelude
import Either
import HTXFloodKit
import Logging


func encode<T: Encodable>(_ encodable: T) -> Either<Error, Data> {
	let encoder = JSONEncoder()
	do {
		return .right(try encoder.encode(encodable))
	} catch {
		return .left(error)
	}
}

func fetchGaugeInfo(completion: @escaping () -> Void) {
// 	let logger = Logger(label: "com.tinyrobot.org.fws")
//     let service = HarrisFWSService(logger: logger)
//     let fileService = FileService(logger: logger)
    
//     let url = URL(fileURLWithPath:"/home/aaron/fws.json")
//     let fetchGaugesEitherIO: EitherIO<Error, GaugeCollection> = service.fetchGages()
//     let encodedF = fetchGaugesEitherIO
//     >>= { gages in 
//         lift( encode(gages) )
//     }
//   	let encodedF = fetchGaugesEitherIO <¢> encode
//   	print(encodedF)
//    service.fetchGauges()
//		<¢> encode
//		>>= curry(fileService.save)(url)
//		.run
//		.parallel
//		.run { results in
//			completion()
//		}
}

func main() {
	fetchGaugeInfo { exit(0) }
    dispatchMain()
}

main()
