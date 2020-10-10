//
//  MainTabBarController.swift
//  ChatNaKolesah
//
//  Created by Михаил Малышев on 03.10.2020.
//  Copyright © 2020 Mikhail Malyshev. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController()
        let peopleViewController = PeopleViewController()
        tabBar.tintColor = .purple
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        let convImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldConfig )!
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldConfig)!
        
        viewControllers = [
        generateNavigationController(rootViewController: listViewController, title: "Conversation", image: convImage),
        generateNavigationController(rootViewController: peopleViewController, title: "People", image: peopleImage)
        ]
    }
    
    
    private func generateNavigationController(rootViewController: UIViewController,
                                              title: String,
                                              image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}
