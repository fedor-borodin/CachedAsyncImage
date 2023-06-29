//
//  CachedAsyncImageImageLoader.swift
//  
//
//  Created by Fedor Borodin on 6/29/23.
//

import UIKit
import SwiftUI

@MainActor
class CachedAsyncImageImageLoader: ObservableObject {
    
    @Published var uiImage: UIImage?
    
    func loadImage(from path: String?) async throws {
        guard let path = path,
        let url = URL(string: path)
        else {
            throw CachedAsyncImageError.badUrl
        }
        
        let filename = url.toFileName()
        let fileProvider = CachedAsyncImageFileProvider.shared
        
        if let nsData = fileProvider.getData(fromFile: filename) {
            let data = nsData as Data
            guard let image = UIImage(data: data) else {
                throw CachedAsyncImageError.badData
            }
            
            uiImage = image
        } else {
            let request = URLRequest(url: url)
            let (localUrl, response) = try await URLSession.shared.download(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                throw CachedAsyncImageError.badResponse
            }
            
            let fileUrl = fileProvider.url?.appendingPathComponent(filename)
            if let fileUrl = fileUrl,
               !fileProvider.manager.fileExists(atPath: fileUrl.path)
            {
                do {
                    try fileProvider.manager.moveItem(atPath: localUrl.path, toPath: fileUrl.path)
                } catch let error {
                    throw error
                }
            }
            
            guard let imageData = fileProvider.getData(fromFile: filename) as Data?,
                  let image = UIImage(data: imageData)
            else {
                throw CachedAsyncImageError.badData
            }
            
            uiImage = image
        }
    }
}
