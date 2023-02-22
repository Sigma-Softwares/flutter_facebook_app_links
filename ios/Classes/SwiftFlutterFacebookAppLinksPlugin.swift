import Flutter
import UIKit
import FBSDKCoreKit


public class SwiftFlutterFacebookAppLinksPlugin: NSObject, FlutterPlugin {

  var deepLinkUrl:String = ""

  public static func register(with registrar: FlutterPluginRegistrar) {

    let instance = SwiftFlutterFacebookAppLinksPlugin()
    let channel = FlutterMethodChannel(name: "plugins.remedia.it/flutter_facebook_app_links", binaryMessenger: registrar.messenger())
    
    instance.initializeSDK()
    
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    // detach
  }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            // Get user consent
            Settings.isAutoInitEnabled = true
            ApplicationDelegate.initializeSDK(nil)
            AppLinkUtility.fetchDeferredAppLink { (url, error) in
                if let error = error {
                    print("Received error while fetching deferred app link %@", error)
                }
                if let url = url {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        
                        self.deepLinkUrl = url.absoluteString
                    } else {
                        UIApplication.shared.openURL(url)
                        
                        self.deepLinkUrl = url.absoluteString
                    }
                }
            }
            return true;
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    switch call.method {
        case "getPlatformVersion":
            handleGetPlatformVersion(call, result: result)
            break
        case "initFBLinks":
            ApplicationDelegate.shared.initializeSDK()
            result(nil)
            return
        case "getDeepLinkUrl":
            result(deepLinkUrl)
        case "activateApp":
            AppEvents.shared.activateApp()
            result(true)
        case "setAdvertiserTracking":
            handleSetAdvertiserTracking(call, result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
        }

  }

  private func handleGetPlatformVersion(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }


  public func initializeSDK() {
    ApplicationDelegate.shared.initializeSDK()
  }

    private func handleSetAdvertiserTracking(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        let enabled = arguments["enabled"] as! Bool
        let collectId = arguments["collectId"] as! Bool
        Settings.shared.isAdvertiserTrackingEnabled = enabled
        Settings.shared.isAdvertiserIDCollectionEnabled = collectId
        result(nil)
    }
}
