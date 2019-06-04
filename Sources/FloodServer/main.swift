import Foundation
import Dispatch
import HTXFloodKit
import Logging

func main() {
    let logger = Logger(label: "com.tinyrobot.org.fws")
    let service = HarrisFWSService(logger: logger)
    service.fetchGages().run.parallel.run { result in
        print(result)
        exit(0)
    }
    
    
//    	DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
// 		print("Exiting")
// 		exit(0)
// 	}	 
    dispatchMain()
}

main()
