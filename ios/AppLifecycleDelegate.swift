import ExpoModulesCore
import YandexLoginSDK

public class AppLifecycleDelegate: ExpoAppDelegateSubscriber {
    public func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) ->  Bool {
      let clientID = Bundle.main.infoDictionary!["YANDEX_OAUTH_CLIENT_ID"] as! String
      
      do {
        try YandexLoginSDK.shared.activate(with: clientID)
      } catch {
        print("Something went wrong while activating YandexLoginSDK")
      }
      
      return true
    }
      
    public func application(
      _ app: UIApplication,
      open url: URL,
      options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      do {
        try YandexLoginSDK.shared.handleOpenURL(url)
      } catch {
        // handle error
      }
      
      return true
    }
      
    public func application(
      _ application: UIApplication,
      continue userActivity: NSUserActivity,
      restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
      do {
        try YandexLoginSDK.shared.handleUserActivity(userActivity)
      } catch {
        // handle error
      }
      
      return true
    }
}
