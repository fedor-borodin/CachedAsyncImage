//
//  CachedAsyncImageError.swift
//  
//
//  Created by Fedor Borodin on 6/29/23.
//

import Foundation

public enum CachedAsyncImageError: Error {
    case badUrl
    case badData
    case badResponse
}
