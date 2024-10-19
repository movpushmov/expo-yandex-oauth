import ExpoModulesCore
import YandexLoginSDK

class AuthObserver: YandexLoginSDKObserver {
    var authorizedHandler: (String, String) -> Void;

    init(authorizedHandler: @escaping (String, String) -> Void) {
        self.authorizedHandler = authorizedHandler;
    }

    func didFinishLogin(with result: Result<LoginResult, any Error>) {
        switch result {
        case .success(let token):
            self.authorizedHandler(token.jwt, token.token)
        case .failure(_):
            break
        }
    }
}

public class ExpoYandexOauthModule: Module {
    private var observer: AuthObserver? = nil;

    public required init(appContext: AppContext) {
        super.init(appContext: appContext)
        
        self.observer = AuthObserver(authorizedHandler: self.authorizedHandler)
    }

    @objc
    private func authorizedHandler(jwtToken: String, token: String) {
        sendEvent("onYandexAuthorized", [
            "jwtToken": jwtToken,
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
            YandexLoginSDK.shared.add(observer: self.observer!)
        }

        OnStopObserving {
            YandexLoginSDK.shared.remove(observer: self.observer!)
        }

        Function("authorize") {
            let rootViewController = UIApplication.shared.delegate?.window??.rootViewController

            return try YandexLoginSDK.shared.authorize(with: rootViewController!)
        }

        Function("logout") {
            return try YandexLoginSDK.shared.logout()
        }
    }
}
