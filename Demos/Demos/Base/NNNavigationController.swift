//
//  NNNavigationController.swift
//  Demos
//
//  Created by tenroadshow on 4.1.22.
//

import UIKit

class NNNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBar.appearance()
        appearance.isTranslucent = false
        appearance.setBackgroundImage(UIImage(color: .white,
                                              size: CGSize(width: screenW,
                                                           height: statusWithNavBarHeight)),
                                      for: .default)
        appearance.shadowImage = UIImage()
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            // 设置导航栏背景色
            appearance.backgroundColor = .white
            // 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
            appearance.shadowColor = UIColor.black
            // 字体颜色
            appearance.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.black
            ]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0  {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "navigationItem_back_black"),
                                                                              style: .done,
                                                                              target: self,
                                                                              action: #selector(childControllerBackAction))
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension NNNavigationController {
    @objc func childControllerBackAction() {
        popViewController(animated: true)
    }
}
