import Foundation
import Logging
import Prelude
import Either

public struct FileService {
    public let save: (URL, Data) -> EitherIO<Error, Prelude.Unit>
    public let read: (URL) -> EitherIO<Error, Data>
}

extension FileService {
    public init(logger: Logger?) {
        self.init(
            save: runSave(logger),
            read: runRead(logger)
        )
    }
}

func runSave(_ logger: Logger?) -> (URL, Data) -> EitherIO<Error, Prelude.Unit> {
	return { url, data in
		return .init(
		    run: .init { callback in
		    	do {
                    logger?.debug("Writing \(url)")
			    	try data.write(to: url, options: .init(rawValue: 0))
			    	callback(.right(unit))
		    	} catch {
		    		callback(.left(error))
		    	}
		    	
		    }
		)
	}
} 

func runRead(_ logger: Logger?) -> (URL) -> EitherIO<Error, Data> {
	return { url in
		return .init(
			run: .init { callback in 
				do {
					let data = try Data(contentsOf: url)
					callback(.right(data))
				} catch {
					callback(.left(error))
				}
			}
		)
	}
}
