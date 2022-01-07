//
//  NSObject+Exception.swift
//  Demos
//
//  Created by tenroadshow on 7.1.22.
//

import Foundation


extension NSObject {
    
    static func openCrashException() {
        instanceMethodSwizzling(cls: self,
                                original: #selector(removeObserver(_:forKeyPath:)),
                                swizzled: #selector(nn_removeObserver(_:forKeyPath:)))
    }
    
    @objc func nn_removeObserver(_ observer: NSObject, forKeyPath keyPath: String) {
        do {
            try nn_removeObserver(observer, forKeyPath: keyPath)
        } catch {
            
    
        }
    }
}
