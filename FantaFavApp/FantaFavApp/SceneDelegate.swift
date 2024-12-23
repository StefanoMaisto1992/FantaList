//
//  SceneDelegate.swift
//  FantaFavApp
//
//  Created by Stefano  Maisto on 20/12/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        let repository = PlayersRepository(),
            useCase = FavouritePlayersUseCase(repository: repository),
            viewModel = FavouritePlayersViewModel(useCase: useCase)
        
        let viewController = FavouritePlayersViewController(viewModel: viewModel) /// Inizializza il ViewController dal XIB
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: true)
        
        window?.rootViewController = navigationController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

