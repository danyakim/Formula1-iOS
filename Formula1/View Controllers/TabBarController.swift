//
//  TabBarController.swift
//  Formula1
//
//  Created by Daniil Kim on 01.06.2021.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - tabBarImages
    
    let tabBarItem1 = UIImage(systemName: "star.fill") ?? UIImage()
    let tabBarItem2 = UIImage(systemName: "archivebox") ?? UIImage()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
    }
    
    // MARK: - Private Methods
    
    private func setupViewControllers() {
        viewControllers = [
            createNavigationController(for: WinnersVC(),
                                       title: "Winners",
                                       image: tabBarItem1),
            createNavigationController(for: ArchiveSearchVC(),
                                       title: "Archive",
                                       image: tabBarItem2)
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
