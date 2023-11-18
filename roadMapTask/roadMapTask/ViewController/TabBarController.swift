//
//  TabBarController.swift
//  roadMapTask
//
//  Created by Kalandarov Vakil on 09.11.2023.
//

import Foundation
import UIKit

class TabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    private func setUpTabBar() {
        UITabBar.appearance().backgroundColor = UIColor(red: 44, green: 44, blue: 46, alpha: 0)
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        self.viewControllers = [createFirstVC(), createSecondVC()]
    }
    
    private func createFirstVC() -> UIViewController {
        let vc = UINavigationController(rootViewController: EpisodesViewController())
        vc.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        vc.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Home"), selectedImage: UIImage(named: "HomeTap"))
        vc.view.backgroundColor = .white
        vc.tabBarItem.imageInsets = UIEdgeInsets(top:0, left: 100, bottom: 0, right: 0)
        vc.tabBarItem.tag = 0
        return vc
    }
    private func createSecondVC() -> UIViewController {
        let vc = UINavigationController(rootViewController: FavouritesViewController())
        vc.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        vc.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "Favourites"), selectedImage: UIImage(named: "FavouritesTap"))
        vc.view.backgroundColor = .white
        vc.tabBarItem.imageInsets = UIEdgeInsets(top:0, left: 0, bottom: 0, right: 100)
        vc.tabBarItem.tag = 1
        return vc
    }
}
