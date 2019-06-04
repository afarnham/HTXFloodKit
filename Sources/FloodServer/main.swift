import Foundation
import Dispatch
import HTXFloodKit
import Logging

//import Html
import HttpPipeline
import Prelude



func main() {
    var logger = Logger(label: "com.tinyrobot.org.fws")
    logger.logLevel = .debug
    let fileService = FileService(logger: logger)
    
    
    let data = fileService.read(URL(fileURLWithPath: "/Users/aaron/fws.json")).run.perform().right!
    let json = String(data: data, encoding: .utf8) ?? "{error: \"Unable to read json\"}"

//    let document: Node = doctype
//        .html(
//            .body(
//                .h1("Welcome!"),
//                .p("You’ve found our site!")
//            )
//        )
//    )

    
    let middleware: Middleware<StatusLineOpen, ResponseEnded, Prelude.Unit, Data> =
        writeStatus(.ok)
            >=> respond(json: json)
    
    run(middleware, on: 8080, baseUrl: URL(string: "http://tyrion.tinyrobot.org")!)
}

main()
