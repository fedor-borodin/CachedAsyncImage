//
//  URL+Method+toFilenameHash.swift
//  
//
//  Created by Fedor Borodin on 6/29/23.
//

import Foundation
import CryptoKit

extension URL {
    
    func toFileName() -> String {
        let result = self.absoluteString
//        result = result.replacingOccurrences(of: "http://", with: "scheme-", options: .literal, range: nil)
//        result = result.replacingOccurrences(of: "https://", with: "scheme-", options: .literal, range: nil)
//        result = result.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
        return md5Hash(result)
    }
    
    func md5Hash(_ source: String) -> String {
        return Insecure.MD5.hash(data: source.data(using: .utf8)!).map {
            String(format: "%02hhx", $0)
        }
        .joined()
    }
}
