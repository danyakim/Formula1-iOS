//
//  TabBarVC.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }
    
    // MARK: - Private Methods
    
    private func setupViewControllers() {
        viewControllers = [
            createNavigationController(for: WinnersVC(),
                                       title: "Winners",
                                       image: K.Images.tabBarItem1,
                                       tag: K.Tags.firstScreen),
            createNavigationController(for: ArchiveSearchVC(),
                                       title: "Archive",
                                       image: K.Images.tabBarItem2,
                                       tag: K.Tags.secondScreen)
        ]
    }
    
    private func createNavigationController(for rootVC: UIViewController,
                                            title: String,
                                            image: UIImage,
                                            tag: Int) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootVC)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.tag = tag
        return navController
    }

}
