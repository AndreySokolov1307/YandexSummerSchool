import UIKit

@MainActor
enum DeviceID {
    static let id = UIDevice.current.identifierForVendor?.uuidString ?? "device"
}
