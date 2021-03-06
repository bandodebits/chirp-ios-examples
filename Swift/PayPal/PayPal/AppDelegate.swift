//
//  AppDelegate.swift
//  PayPal
//
//  Created by Joe Todd on 22/06/2018.
//  Copyright © 2019 Chirp. All rights reserved.
//

import UIKit
import ChirpSDK

struct StateManager {
    static var accessToken = ""
    static var payerId = ""
    static var paymentId = ""
    static var paymentToken = ""
}

extension URL {
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        return parameters
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var chirp: ChirpService?
    var apiClient: PayPalAPIClient = PayPalAPIClient()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        apiClient.send(PayPalAuthenticate(clientId: PAYPAL_CLIENT_ID, clientSecret: PAYPAL_CLIENT_SECRET)) { response in
            switch response {
            case .success(let data):
                
                guard let data = data as? [String:Any] else {return}
                guard let accessToken = data["access_token"] as? String else {return}
                StateManager.accessToken = accessToken
                
            case .failure(let error):
                print(error)
            }
        }
        
        chirp = ChirpService()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if let chirp = chirp, let sdk = chirp.sdk {
            if sdk.state != CHIRP_SDK_STATE_STOPPED {
                chirp.stop()
            }
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if let chirp = chirp, let sdk = chirp.sdk {
            if sdk.state != CHIRP_SDK_STATE_STOPPED {
                chirp.stop()
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let chirp = chirp, let sdk = chirp.sdk {
            if sdk.state == CHIRP_SDK_STATE_STOPPED {
                chirp.start()
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if let chirp = chirp, let sdk = chirp.sdk {
            if sdk.state == CHIRP_SDK_STATE_STOPPED {
                chirp.start()
            }
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        if let chirp = chirp, let sdk = chirp.sdk {
            if sdk.state != CHIRP_SDK_STATE_STOPPED {
                chirp.stop()
            }
        }
    }
}

