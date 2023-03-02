//
//  BaseNavgationController.swift
//  IndustryAR
//
//  Created by 吴熠 on 2/27/23.
//

import UIKit

class BaseNavgationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.shadowImage = UIImage()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !children.isEmpty {
            viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", imageName: "", target: self, action: #selector(back))
            viewController.hidesBottomBarWhenPushed = true
        }

        super.pushViewController(viewController, animated: animated)

    }
    @objc private func back() {
        popViewController(animated: true)
    }
}

extension UIBarButtonItem {

    convenience init(title: String="", imageName: String? = nil, target: Any?, action: Selector?) {
        let btn = UIButton()
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.black, for: .highlighted)
        btn.titleLabel?.font = UIFont.regularSize(size: 15)

        if let img = imageName {
            btn.setImage( UIImage(named: img), for: .normal)
            btn.setImage(UIImage(named: img + "_highlighted"), for: .highlighted)

        }

        if let ac = action {
            btn.addTarget(target, action: ac, for: .touchUpInside)
        }
        btn.sizeToFit()

       self.init()
        self.customView = btn
    }
}
