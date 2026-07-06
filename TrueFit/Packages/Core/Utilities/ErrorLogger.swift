import Foundation

final class ErrorLogger {
    static func log(_ error: AppError, context: String) {
        #if DEBUG
        print("❌ [\(context)] \(error.userMessage) | Severity: \(error.severity)")
        #endif
        // Future: send to Crashlytics/Sentry based on error.severity
        // .critical and .high → send to remote logger
        // .low and .medium → local only
    }
}
