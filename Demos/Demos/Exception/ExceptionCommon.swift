//
//  ExceptionCommon.swift
//  Demos
//
//  Created by tenroadshow on 7.1.22.
//

import Foundation


/// 交换对象方法
/// - Parameters:
///   - cls: 需要交换方法的对象
///   - original: 原方法
///   - swizzled: 需要交换的方法
func instanceMethodSwizzling(cls: AnyClass, original: Selector, swizzled: Selector) {
   guard let originalMethod = class_getInstanceMethod(cls, original),
         let swizzledMethod = class_getInstanceMethod(cls, swizzled) else { return }
    /*
     在进行Swizzling的时候,需要用class_addMethod先进行判断一下原有类中是否有要替换方法的实现
     如果class_addMethod返回yes:说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到method_getImplemetation去获取class_getInstanceMethod里面的方法实现,然后再进行class_replaceMethod来实现Swizzing
     */
    let addedMethod = class_addMethod(cls,
                                      original,
                                      method_getImplementation(swizzledMethod),
                                      method_getTypeEncoding(swizzledMethod))
    if addedMethod {
        class_replaceMethod(cls,
                            swizzled,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod))
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}


/// 交换类方法
/// - Parameters:
///   - cls: 需要交换的类
///   - original: 原方法
///   - swizzled: 需要交换的方法
func classMethodSwizzling(cls: AnyClass, original: Selector, swizzled: Selector) {
   guard let metaclass = objc_getMetaClass(NSStringFromClass(cls)) as? AnyClass,
         let originalMethod = class_getClassMethod(cls, original),
         let swizzledMethod = class_getClassMethod(cls, swizzled) else { return }
    
    
    
    let addedMethod = class_addMethod(metaclass,
                                      original,
                                      method_getImplementation(swizzledMethod),
                                      method_getTypeEncoding(swizzledMethod))
    if addedMethod {
        class_replaceMethod(cls,
                            swizzled,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod))
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}


class NNCrashException: NSObject {
    
    
    
}
