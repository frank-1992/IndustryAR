//
//  RootRTabbarController.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/27/23.
//

import UIKit

class RootTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.unselectedItemTintColor = .lightCT
        tabBar.tintColor = .lightThemeP
        tabBar.backgroundColor = .tabbarLightColor
        
        addControllers()
    }
    
    private func addControllers() {
        addChildViewController(vc: CurrentProjectListController(), title: project.localizedString(), imgName: "Home")
        addChildViewController(vc: HistoryProjectListController(), title: history.localizedString(), imgName: "Folders")
        addChildViewController(vc: MineViewController(), title: mine.localizedString(), imgName: "Mine")
        selectedIndex = 0
    }
    
    private func addChildViewController(vc: UIViewController, title: String, imgName: String) {
        vc.tabBarItem.image = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.selectedImage = UIImage(named: imgName+"-selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.lightCT], for: .normal)
        vc.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 11), .foregroundColor: UIColor.lightCP], for: .selected)
        vc.tabBarItem.title = title
        vc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        vc.tabBarItem.badgeValue = nil
        vc.navigationItem.title = title
        let nav = BaseNavgationController(rootViewController: vc)
        self.addChild(nav)
    }
    
}
