//
//  MainTabViewController.swift
//  Puhaha
//
//  Created by JiwKang on 2022/07/20.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableTab = MainViewController()
        tableTab.tabBarItem = UITabBarItem(title: "식탁", image: UIImage(named: "icon-tab-bar-table") ?? UIImage(), selectedImage: UIImage(named: "icon-tab-bar-table") ?? UIImage())
        tableTab.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -4, right: 0)
        tableTab.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 6.0)
        
        let statisticTab = StatisticViewController()
        statisticTab.tabBarItem = UITabBarItem(title: "통계", image: UIImage(named: "icon-tab-bar-statistic") ?? UIImage(), selectedImage: UIImage(named: "icon-tab-bar-statistic") ?? UIImage())
        statisticTab.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -4, right: 0)
        statisticTab.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 6.0)
        
        viewControllers = [tableTab, statisticTab]
        tabBar.tintColor = UIColor(named: "TabBarIconSelectedColor") ?? UIColor()
        tabBar.unselectedItemTintColor = UIColor(named: "TabBarIconUnSelectedColor")
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
}

/**
 tab bar shadow
 출처: https://velog.io/@leejh3224/iOS-TabBar-shadow-커스터마이징-trjugzee87
 */
extension CALayer {
    func applyShadow(
        color: UIColor = .black,
        alpha: Float = 0.50,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur
    }
}

extension UITabBar {
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
