//
//  TabBarController.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }
    
    // MARK: - Private Methods
    
    private func setupViewControllers() {
        viewControllers = [
            createNavigationController(for: WinnersVC(),
                                       title: "Winners",
                                       image: K.Images.tabBarItem1),
            createNavigationController(for: ArchiveSearchVC(),
                                       title: "Archive",
                                       image: K.Images.tabBarItem2)
        ]
    }
    
    private func createNavigationController(for rootVC: UIViewController,
                                            title: String,
                                            image: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootVC)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }

}
