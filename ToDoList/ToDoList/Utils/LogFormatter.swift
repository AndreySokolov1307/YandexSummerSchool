import Foundation
import CocoaLumberjackSwift

final class LogFormatter: NSObject, DDLogFormatter {
 
    func format(message logMessage: DDLogMessage) -> String? {
        let logLevel: String
        
        switch logMessage.flag {
        case .error:
            logLevel = Constants.Strings.logError
        case .warning:
            logLevel = Constants.Strings.logWarning
        case .info:
            logLevel = Constants.Strings.logInfo
        case .debug:
            logLevel = Constants.Strings.logDebug
        default:
            logLevel = Constants.Strings.logDefault
        }

        return "\(logLevel) | \(logMessage.message)"
    }
}

