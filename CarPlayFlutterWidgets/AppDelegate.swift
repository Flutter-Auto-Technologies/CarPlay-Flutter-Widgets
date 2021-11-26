//
//  AppDelegate.swift
//  CarPlayFlutterWidgets
//
//  Created by Fotios Dimanidis on 24.11.21.
//

import UIKit
import CarPlay
import Flutter

@main
class AppDelegate: UIResponder, UIApplicationDelegate, CPApplicationDelegate, CPMapTemplateDelegate {
    
    var carPlayWindow: CPWindow?
    var interfaceController: CPInterfaceController?
    lazy var mapTemplate: CPMapTemplate = {
        let mapTemplate = CPMapTemplate()
        
        let searchBarButton = CPBarButton(type: .text) { (barButton) in
            DispatchQueue.main.async {
                self.interactionChannel?.invokeMethod("incrementCounter", arguments: nil)
            }
        }
        searchBarButton.title = "     +     "
        mapTemplate.leadingNavigationBarButtons = [searchBarButton]
        
        return mapTemplate
    }()
    
    lazy var flutterEngine = FlutterEngine(name: "CarPlayFlutterWidgets Flutter engine")
    
    var interactionChannel : FlutterMethodChannel?
    
    func application(_ application: UIApplication, didConnectCarInterfaceController interfaceController: CPInterfaceController, to window: CPWindow) {
        self.interfaceController = interfaceController
        self.carPlayWindow = window
        
        mapTemplate.mapDelegate = self
        interfaceController.setRootTemplate(mapTemplate, animated: true)
        
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let controller = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        window.rootViewController = controller
        interactionChannel = FlutterMethodChannel.init(name: "com.navideck.CarPlayFlutterWidgets/interaction", binaryMessenger: controller.binaryMessenger)

    }
    
    func application(_ application: UIApplication, didDisconnectCarInterfaceController interfaceController: CPInterfaceController, from window: CPWindow) {
        // Not used
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        flutterEngine.run();
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

