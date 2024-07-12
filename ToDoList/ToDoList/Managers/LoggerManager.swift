import Foundation
import CocoaLumberjackSwift

private enum LoggerConstants {
    static let rollingFrequency: TimeInterval = 60 * 60 * 24
    static let maxNumberOfLogFiles: UInt = 3
}

enum LoggerManager {
    
    // MARK: - Static Methods
    
    static func setupLoggers() {
        let consoleLogger = DDOSLogger.sharedInstance
        consoleLogger.logFormatter = LogFormatter()
        
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = LoggerConstants.rollingFrequency
        fileLogger.logFileManager.maximumNumberOfLogFiles = LoggerConstants.maxNumberOfLogFiles
        fileLogger.logFormatter = LogFormatter()
   
        DDLog.add(consoleLogger, with: .all)
        DDLog.add(fileLogger, with: .error)
    }
}
