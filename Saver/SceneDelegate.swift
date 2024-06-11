//
//  SceneDelegate.swift
//  Saver
//
//  Created by 이상민 on 6/3/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //MARK: - Tabar 실행
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let homeViewController = HomeViewController()
        let reportViewController = ReportViewController()
        
        let firstNavigationController = UINavigationController(rootViewController: homeViewController)
        let secondNavigationController = UINavigationController(rootViewController: reportViewController)
        
        // HomeViewController가 나타난 후 자동으로 AddAmountViewController로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let addAmountViewController = AddAmountViewController()
            homeViewController.navigationController?.pushViewController(addAmountViewController, animated: true)
        }
        
        firstNavigationController.tabBarItem = UITabBarItem(title: "가계부", image: UIImage(systemName: "calendar"), tag: 0)
        secondNavigationController.tabBarItem = UITabBarItem(title: "리포트", image: UIImage(systemName: "chart.bar"), selectedImage: UIImage(systemName: "chart.bar.fill"))
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstNavigationController, secondNavigationController]
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

