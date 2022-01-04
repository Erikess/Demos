//
//  NNConstant.swift
//  Demos
//
//  Created by tenroadshow on 4.1.22.
//

import UIKit


// MARK: - UI相关
public var isX : Bool {
    var isX = false
    if #available(iOS 11.0, *) {
        let bottom : CGFloat = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
        isX = bottom > 0.0
    }
    return isX
}

public let screenW = UIScreen.main.bounds.size.width
public let screenH = UIScreen.main.bounds.size.height

/// 状态栏的高度
public  var statusBarHeight : CGFloat {
    return isX ? 44.0 : 20.0
}

/// 状态栏的高度
public  var navBarHeight: CGFloat {
    return 44.0
}
/// 状态栏+导航栏的高度
public  var statusWithNavBarHeight: CGFloat {
   return statusBarHeight + navBarHeight
}

/// tabbar的高度
public  var tabbarHeight: CGFloat {
    return 49.0
}

/// 底部安全距离的高度
public  var safeBottomHeight : CGFloat {
    if let inset = UIApplication.shared.keyWindow?.safeAreaInsets {
        return inset.bottom
    }else {
        return isX ? 34.0 : 0.0
    }
}

/// tabbarHeight+底部安全区域的高度
public  var tabbarWithBottomSafe: CGFloat {
    return tabbarHeight + safeBottomHeight
}


/// 根据宽度缩放
public  func scaleW(_ width: CGFloat,fit:CGFloat = 375.0) -> CGFloat {
    return screenW / fit * width
}
/// 根据高度缩放
public  func scaleH(_ height: CGFloat,fit:CGFloat = 812.0) -> CGFloat {
    return screenH / fit * height
}
