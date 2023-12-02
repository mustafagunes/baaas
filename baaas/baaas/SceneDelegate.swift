//
//  SceneDelegate.swift
//  baaas
//
//  Created by Mustafa Gunes on 2.12.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .white
    window?.windowScene = windowScene
    window?.rootViewController = UINavigationController(rootViewController: BaaasHomeViewController())
    window?.makeKeyAndVisible()
  }
}
