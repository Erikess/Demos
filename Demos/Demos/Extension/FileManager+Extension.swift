//
//  FileManager.swift
//  Demos
//
//  Created by tenroadshow on 5.1.22.
//

import Foundation


public enum FileType {
    case userInfo
    case cookie
    
    var filePath: String {
        switch self {
        case .userInfo:
            return (FileManager.documnetsDirectory() as NSString).appendingPathComponent("userInfo")
        case .cookie:
            return (FileManager.documnetsDirectory() as NSString).appendingPathComponent("cookie")
        }
    }
}


extension FileManager {
    static func store<DecodedObjectType>(type: FileType, object: DecodedObjectType.Type) -> Bool where DecodedObjectType: NSObject, DecodedObjectType: NSCoding  {
        return write(object: object, targetFile: type.filePath)
    }
    
    static func object<DecodedObjectType>(type: FileType,
                                          ofClass: DecodedObjectType.Type) -> DecodedObjectType? where DecodedObjectType: NSObject, DecodedObjectType: NSCoding {
        return read(ofClass: ofClass, targetFile: type.filePath)
    }
}




public extension FileManager {
    
    /// 文件管理器
    static var fileManager: FileManager {
        return FileManager.default
    }

    static func documnetsDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                   .userDomainMask,
                                                   true).first ?? ""
    }

    
    /// 判断路径上文件、文件夹是否存在
    /// - Parameter filePath: 路径
    /// - Returns: 结果
    static func ifFileOrFolderExists(filePath: String) -> Bool {
        return fileManager.fileExists(atPath: filePath)
    }

    
    
    /// 移除文件/文件夹
    /// - Parameter filePath: 文件路径
    /// - Returns: 结果
    @discardableResult
    static func removefile(filePath: String) -> Bool {
        if ifFileOrFolderExists(filePath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
                return true
            } catch {
                return false
            }
        }else {
            return false
        }
    }
    
    static func write<DecodedObjectType>(object: DecodedObjectType.Type, targetFile: String) -> Bool where DecodedObjectType: NSObject, DecodedObjectType: NSCoding {
        do {
            let archiveredData = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            try archiveredData.write(to: URL(fileURLWithPath: targetFile))
            return true
        } catch  {
            return false
        }
    }
    
    static func read<DecodedObjectType>(ofClass: DecodedObjectType.Type, targetFile: String) -> DecodedObjectType? where DecodedObjectType: NSObject, DecodedObjectType: NSCoding {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: targetFile))
            let someObject = try NSKeyedUnarchiver.unarchivedObject(ofClass: ofClass, from: data)
            return someObject
        } catch {
            return nil
        }
    }
}




class NNCookie: NSObject, NSCoding {
    
    var cookie: HTTPCookie = HTTPCookie()
    
    required init?(coder: NSCoder) {
        
    }

    func encode(with coder: NSCoder) {
        
    }

}

