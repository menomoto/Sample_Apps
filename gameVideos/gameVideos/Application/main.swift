import Foundation
import UIKit


if NSClassFromString("XCTestCase") != nil {
    UIApplicationMain(
        Process.argc,
        Process.unsafeArgv,
        NSStringFromClass(UIApplication),
        NSStringFromClass(TestingAppDelegate)
    )
} else {
    UIApplicationMain(
        Process.argc,
        Process.unsafeArgv,
        NSStringFromClass(UIApplication),
        NSStringFromClass(AppDelegate)
    )
}
