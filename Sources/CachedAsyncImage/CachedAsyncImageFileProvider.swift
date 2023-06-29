//
//  CachedAsyncImageFileProvider.swift
//  
//
//  Created by Fedor Borodin on 6/29/23.
//

import Foundation

final class CachedAsyncImageFileProvider {
    
    static let shared = CachedAsyncImageFileProvider()
        
    let manager: FileManager
    let queue: DispatchQueue
    private(set) var url: URL?

    private var folderName = "MyFolder"
    
    private init() {
        self.manager = .default
        self.queue = .global(qos: .background)
        self.url = CachedAsyncImageFileProvider.getPath(in: folderName)
    }

    public func getData(fromFile file: String) -> NSData? {
        if let filePath = self.url?.appendingPathComponent(file),
           let selfUrl = self.url
        {
            return self.manager.fileExists(atPath: (selfUrl.appendingPathComponent(file)).path) ? NSData(contentsOfFile: filePath.path) : nil
        }
        return nil
    }
    
    public func setFolderName(_ name: String) {
        self.folderName = name
        self.url = Self.getPath(in: name)
    }
}

extension CachedAsyncImageFileProvider {
    
    static func getPath(in folder: String) -> URL? {
        do {
            let res = try self.createDirectory(folder)
            return res
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private static func createDirectory(_ folder: String) throws -> URL {
        let manager: FileManager = .default
        let defaultPathsSearch: URL
        let newFolder:URL
        
        do {
            defaultPathsSearch = try manager.url(for: FileManager.SearchPathDirectory.cachesDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask,
                                                 appropriateFor: nil,
                                                 create: true)
        } catch {
            throw(FileProviderError.getFolder(folder))
        }
        
        newFolder = defaultPathsSearch.appendingPathComponent(folder)
        
        if !manager.fileExists(atPath: newFolder.path) {
            do {
                try manager.createDirectory(at: newFolder, withIntermediateDirectories: false, attributes: nil)
            } catch {
                throw(FileProviderError.createFolder(folder))
            }
        }
        
        return newFolder
    }
}

enum FileProviderError: Error {
    case getFolder(_ folder: String)
    case createFolder(_ folder: String)
    
    var localizedDescription: String {
        switch self {
        case .getFolder(let folder):
            return "Error getting folder: \(folder)"
        case .createFolder(let folder):
            return "Error creating folder: \(folder)"
        }
    }
}
