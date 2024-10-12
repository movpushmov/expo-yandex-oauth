import ExpoModulesCore
import YandexLoginSDK

class AuthObserver: YandexLoginSDKObserver {
    var authorizedHandler: (String) -> Void;
    
    init(authorizedHandler: @escaping (String) -> Void) {
        self.authorizedHandler = authorizedHandler;
    }
    
    func didFinishLogin(with result: Result<LoginResult, any Error>) {
        switch result {
        case .success(let token):
            self.authorizedHandler(token.jwt)
        case .failure(let error):
            break
        }
    }
}

public class ExpoYandexOauthModule: Module {
    @objc
    private func authorizedHandler(token: String) {
        sendEvent("onYandexAuthorized", [
          "token": token
        ])
    }
    
  public func definition() -> ModuleDefinition {
    Name("ExpoYandexOauth")

    Constants([
        :
    ])

    Events("onYandexAuthorized")
      
      OnStartObserving {
          YandexLoginSDK.shared.add(observer: AuthObserver(authorizedHandler: self.authorizedHandler))
      }

    Function("authorize") {
        let rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        
        return try YandexLoginSDK.shared.authorize(with: rootViewController!)
    }
      
    Function("logout") {
        return try YandexLoginSDK.shared.logout()
    }

    // Defines a JavaScript function that always returns a Promise and whose native code
    // is by default dispatched on the different thread than the JavaScript runtime runs on.
    /*AsyncFunction("setValueAsync") { (value: String) in
      // Send an event to JavaScript.
      self.sendEvent("onChange", [
        "value": value
      ])
    }

    // Enables the module to be used as a native view. Definition components that are accepted as part of the
    // view definition: Prop, Events.
    View(ExpoYandexOauthView.self) {
      // Defines a setter for the `name` prop.
      Prop("name") { (view: ExpoYandexOauthView, prop: String) in
        print(prop)
      }
    }*/
  }
}
