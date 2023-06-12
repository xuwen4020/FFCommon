//
//  FileManager+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation

// MARK: - FileManager extension
public enum FilePathError: Error {
    case jsonSerialization
    case errorLoadingSound
    case pathNotExist
    case pathNotAllowed
}

public extension FileManager {
    // MARK: - Variables
    
    /// Path type enum.
    enum PathType: Int {
        /// Main bundle path.
        case mainBundle
        /// Library path.
        case library
        /// Documents path.
        case documents
        /// Cache path.
        case cache
        /// Application Support path.
        case applicationSupport
        /// Temporary path.
        case temporary
    }
    
    // MARK: - Functions
    
    /// 获取 PathType 的路径
    ///
    /// - Parameter path: 路径 type.
    /// - Returns: 返回路径类型字符串
    func pathFor(_ path: PathType) -> String? {
        var pathString: String?
        
        switch path {
        case .mainBundle:
            pathString = mainBundlePath()

        case .library:
            pathString = libraryPath()

        case .documents:
            pathString = documentsPath()

        case .cache:
            pathString = cachePath()

        case .applicationSupport:
            pathString = applicationSupportPath()

        case .temporary:
            pathString = temporaryPath()
        }
        
        return pathString
    }
    
    /// 保存给定内容的文件
    ///
    /// - Parameters:
    ///   - file: 要保存的文件
    ///   - path: 文件路径
    ///   - content: 要保存的内容
    /// - Throws: write(toFile:, atomically:, encoding:) errors.
    func save(file: String, in path: PathType, content: String) throws {
        guard let path = FileManager.default.pathFor(path) else {
            return
        }
        
        try content.write(toFile: path.appendingPathComponent(file), atomically: true, encoding: .utf8)
    }
    
    /// 读取文件并将内容作为字符串返回
    ///
    /// - Parameters:
    ///   - file: 要读取的文件
    ///   - path: 文件路径
    /// - Returns: 返回文件内容一个字符串
    /// - Throws: Throws String(contentsOfFile:, encoding:) errors.
    func read(file: String, from path: PathType) throws -> String? {
        guard let path = FileManager.default.pathFor(path) else {
            return nil
        }
        
        return try String(contentsOfFile: path.appendingPathComponent(file), encoding: .utf8)
    }
    
    /// 将对象保存到具有给定文件名的 plist 中。
    ///
    /// - Parameters:
    ///   - object: 要保存到 plist 中的对象
    ///   - path: plist 路径
    ///   - filename: plist 文件名.
    /// - Returns: Returns true if the operation was successful, otherwise false.
    @discardableResult
    func savePlist(object: Any, in path: PathType, filename: String) -> Bool {
        let path = checkPlist(path: path, filename: filename)
        
        var isSuccessful = false
        
        guard !path.exist else {
//            return NSKeyedArchiver.archiveRootObject(object, toFile: path.path)
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
                try data.write(to: path.path.url!)
                isSuccessful = true
            } catch {
                print(error)
                isSuccessful = false
            }
            return isSuccessful
        }
        
        return isSuccessful
    }
    
    /// 从具有给定文件名的 plist 加载对象。
    ///
    /// - Parameters:
    ///   - path: plist 的路径
    ///   - filename: plist 文件名
    /// - Returns: 返回加载的对象
    func readPlist(from path: PathType, filename: String) -> Any? {
        let path = checkPlist(path: path, filename: filename)
        
        guard !path.exist else {
            do {
                let data = try Data(contentsOf: path.path.url!)
                return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)
            } catch {
                debugPrint("unarchive failure in init")
                return nil
            }
//            return NSKeyedUnarchiver.unarchiveObject(withFile: path.path)
        }
        
        return nil
    }
    
    /// 检查 plist 是否存在
    ///
    /// - Parameters:
    ///   - path: plist 的路径
    ///   - filename: plist 文件名
    /// - Returns: exist： 是否存在plist   path：plist路径
    private func checkPlist(path: PathType, filename: String) -> (exist: Bool, path: String) {
        guard let path = FileManager.default.pathFor(path), let finalPath = path.appendingPathComponent(filename).appendingPathExtension("plist") else {
            return (false, "")
        }
        
        return (true, finalPath)
    }
    
    /// 获取文件名的 Main Bundle 路径
    /// 如果没有指定文件，则返回main Bundle路径
    ///
    /// - Parameter file: 文件名
    /// - Returns: 以字符串形式返回路径
    func mainBundlePath(file: String = "") -> String? {
        file.isEmpty ? Bundle.main.bundlePath : Bundle.main.path(forResource: file.deletingPathExtension, ofType: file.pathExtension)
    }
    
    /// 获取文件名的Documents路径
    ///
    /// - Parameter file: 文件名
    /// - Returns: 以字符串形式返回路径
    func documentsPath(file: String = "") -> String? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return documentsURL.path.appendingPathComponent(file)
    }
    
    /// 获取文件名的Library路径
    ///
    /// - Parameter file: 文件名
    /// - Returns: 以字符串形式返回路径
    func libraryPath(file: String = "") -> String? {
        guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return libraryURL.path.appendingPathComponent(file)
    }
    
    /// 获取文件名的Cache路径
    ///
    /// - Parameter file: 文件名
    /// - Returns: 以字符串形式返回路径
    func cachePath(file: String = "") -> String? {
        guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return cacheURL.path.appendingPathComponent(file)
    }
    
    /// 获取文件名的应用程序支持路径
    ///
    /// - Parameter file: 文件名
    /// - Returns: 以字符串形式返回路径
    func applicationSupportPath(file: String = "") -> String? {
        guard let applicationSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        if !FileManager.default.fileExists(atPath: applicationSupportURL.absoluteString, isDirectory: nil) {
            do {
                try FileManager.default.createDirectory(atPath: applicationSupportURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }
        
        return applicationSupportURL.path.appendingPathComponent(file)
    }
    
    /// 获取文件名的临时路径
    ///
    /// - Parameter file: 文件名
    /// - Returns: 以字符串形式返回路径
    func temporaryPath(file: String = "") -> String? {
        NSTemporaryDirectory().appendingPathComponent(file)
    }
    
    /// 返回文件大小
    ///
    /// - Parameters:
    ///   - file: 文件名
    ///   - path: 文件的路径
    /// - Returns: 返回文件大小。
    /// - Throws: 抛出 FileManager.default.attributesOfItem(atPath:) errors.
    func size(file: String, from path: PathType) throws -> Float? {
        if !file.isEmpty {
            guard let path = FileManager.default.pathFor(path) else {
                return nil
            }
            
            let finalPath = path.appendingPathComponent(file)
            
            if FileManager.default.fileExists(atPath: finalPath) {
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: finalPath)
                return fileAttributes[FileAttributeKey.size] as? Float
            }
        }
        
        return nil
    }
    
    /// 删除具有给定文件名的文件
    ///
    /// - Parameters:
    ///   - file: 要删除的文件
    ///   - path: 文件的路径。
    /// - Throws: 抛出FileManager.default.removeItem(atPath:) 错误。
    func delete(file: String, from path: PathType) throws {
        if !file.isEmpty {
            guard let path = FileManager.default.pathFor(path) else {
                throw FilePathError.pathNotExist
            }
            
            if FileManager.default.fileExists(atPath: path.appendingPathComponent(file)) {
                try FileManager.default.removeItem(atPath: path.appendingPathComponent(file))
            }
        }
    }
    
    /// 将文件从路径移动到另一个路径
    ///
    /// - Parameters:
    ///   - file: 要移动的文件名
    ///   - origin: 文件的原始路径
    ///   - destination:  文件的目标路径
    /// - Returns: 如果操作成功，则返回 true，否则返回 false。
    /// - Throws: 抛出FileManager.default.moveItem(atPath:, toPath:) 和 FilePathError 错误。
    func move(file: String, from origin: PathType, to destination: PathType) throws {
        let paths = try check(file: file, origin: origin, destination: destination)
        
        if paths.fileExist {
            try FileManager.default.moveItem(atPath: paths.origin, toPath: paths.destination)
        }
    }
    
    /// 将文件复制到另一个路径。
    ///
    /// - Parameters:
    ///   - file: 要复制的文件名
    ///   - origin: 原始路径
    ///   - destination: 目标路径
    /// - Returns: 如果操作成功，则返回 true，否则返回 false
    /// - Throws: 抛出FileManager.default.copyItem(atPath:, toPath:) 和 FilePathError 错误。
    func copy(file: String, from origin: PathType, to destination: PathType) throws {
        let paths = try check(file: file, origin: origin, destination: destination)
        
        if paths.fileExist {
            try FileManager.default.copyItem(atPath: paths.origin, toPath: paths.destination)
        }
    }
    
    /// 检查原始路径、目标路径和文件是否存在。
    ///
    /// - Parameters:
    ///   - file: 要检查的文件名.
    ///   - origin: 原始路径
    ///   - destination: 目标路径
    /// - Returns: 返回一个元组，其中包含源、目标和文件是否存在
    /// - Throws: 抛出FilePathError 错误。
    private func check(file: String, origin: PathType, destination: PathType) throws -> (origin: String, destination: String, fileExist: Bool) { // swiftlint:disable:this large_tuple
        guard let originPath = FileManager.default.pathFor(origin), let destinationPath = FileManager.default.pathFor(destination) else {
            throw FilePathError.pathNotExist
        }
        
        guard destination != .mainBundle else {
            throw FilePathError.pathNotAllowed
        }
        
        let finalOriginPath = originPath.appendingPathComponent(file)
        let finalDestinationPath = destinationPath.appendingPathComponent(file)
        
        guard !FileManager.default.fileExists(atPath: finalOriginPath) else {
            return (finalOriginPath, finalDestinationPath, true)
        }
        
        return (finalOriginPath, finalDestinationPath, false)
    }
    
    /// 重命名文件
    ///
    /// - Parameters:
    ///   - file: 要重命名的文件名
    ///   - origin: 原文件名
    ///   - newName: 新文件名
    /// - Returns:如果操作成功，则返回 true，否则返回 false
    /// - Throws: 抛出 FileManager.default.copyItem(atPath:, toPath:)、FileManager.default.removeItem(atPath:, toPath:) 和 FilePathError 错误。
    func rename(file: String, in origin: PathType, to newName: String) throws {
        guard let originPath = FileManager.default.pathFor(origin) else {
            throw FilePathError.pathNotExist
        }
        
        let finalOriginPath = originPath.appendingPathComponent(file)
        
        if FileManager.default.fileExists(atPath: finalOriginPath) {
            let destinationPath: String = finalOriginPath.replacingOccurrences(of: file, with: newName)
            try FileManager.default.copyItem(atPath: finalOriginPath, toPath: destinationPath)
            try FileManager.default.removeItem(atPath: finalOriginPath)
        }
    }
    
    /// 设置 带"-Settings.plist" 的对象  如果文件不存在，该文件将保存在库路径中
    ///
    /// - Parameters:
    ///   - filename: 设置文件名  “-Settings.plist”将被自动添加。
    ///   - object: 要设置的对象
    ///   - objKey: 对象 key.
    /// - Returns: 如果操作成功，则返回 true，否则返回 false
    /// - Throws: 抛出 FilePathError 错误
    @discardableResult
    func setSettings(filename: String, object: Any, forKey objectKey: String) -> Bool {
        guard var path = FileManager.default.pathFor(.applicationSupport) else {
            return false
        }
        
        path = path.appendingPathComponent("\(filename)-Settings.plist")
        
        var settings: [String: Any]
        
        if let plistData = try? Data(contentsOf: URL(fileURLWithPath: path)), let plistFile = try? PropertyListSerialization.propertyList(from: plistData, format: nil), let plistDictionary = plistFile as? [String: Any] {
            settings = plistDictionary
        } else {
            settings = [:]
        }
        
        settings[objectKey] = object
        
        do {
            let plistData = try PropertyListSerialization.data(fromPropertyList: settings, format: .xml, options: 0)
            try plistData.write(to: URL(fileURLWithPath: path))
            
            return true
        } catch {
            return false
        }
    }
    
    /// 获取 带"-Settings.plist" 的对象
    ///
    /// - Parameters:
    ///   - filename: 文件名：设置文件名。 “-Settings.plist”将被自动添加
    ///   - forKey: 对象键
    /// - Returns: 返回给定键的对象
    func getSettings(filename: String, forKey objectKey: String) -> Any? {
        guard var path = FileManager.default.pathFor(.applicationSupport) else {
            return nil
        }
        
        path = path.appendingPathComponent("\(filename)-Settings.plist")
        
        var settings: [String: Any]
        
        if let plistData = try? Data(contentsOf: URL(fileURLWithPath: path)), let plistFile = try? PropertyListSerialization.propertyList(from: plistData, format: nil), let plistDictionary = plistFile as? [String: Any] {
            settings = plistDictionary
        } else {
            settings = [:]
        }
        
        return settings[objectKey]
    }
}

