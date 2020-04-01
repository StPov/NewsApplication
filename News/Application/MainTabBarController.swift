//
//  MainTabBarController.swift
//  News
//
//  Created by Stanislav Povolotskiy on 01.04.2020.
//  Copyright © 2020 Stanislav Povolotskiy. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let sourceVC = SourceCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let newsVC = UIViewController()
        let favoritesVC = UIViewController()
        
        viewControllers = [
            generateNavigationController(rootViewController: sourceVC, title: "Sources", image: UIImage(named: "list")!),
            generateNavigationController(rootViewController: newsVC, title: "Фотографии", image: UIImage(named: "list1")!),
            generateNavigationController(rootViewController: favoritesVC, title: "Избранное", image: UIImage(named: "fav")!)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        if Core.share.isNewUser() {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let vc = storyboard.instantiateViewController(withIdentifier: "welcome") as? WelcomeVC {
//                vc.modalPresentationStyle = .fullScreen
//                present(vc, animated: true)
//            }
//        }
//    }
}
