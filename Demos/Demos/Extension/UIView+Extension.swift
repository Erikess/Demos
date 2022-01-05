//
//  UIView+Extension.swift
//  Demos
//
//  Created by tenroadshow on 4.1.22.
//

import UIKit



extension UIView {
    static var reuseId: String {
        return NSStringFromClass(self.classForCoder())
    }
}
