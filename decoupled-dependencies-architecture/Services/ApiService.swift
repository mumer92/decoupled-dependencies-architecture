//
//  ApiService.swift
//  unit-test-dependencies-tutorial
//
//  Created by David Martinez-Lebron on 4/18/18.
//  Copyright © 2018 David Martinez-Lebron. All rights reserved.
//

import Foundation

enum UrlAddress {
    
    static let base = "https://itunes.apple.com/search"
    
    case parameters(parameters: [Parameter: String])
    
    var full: String {
        
        if case let UrlAddress.parameters(parameters) = self {
            
            let encodedParams = parameters.reduce("") { (result, key) in
                guard let encodedValue = key.value.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return "" }
                return result + "&\(key.key.rawValue)=\(encodedValue)"
            }
            
            return "\(UrlAddress.base)?\(encodedParams)"
        }
        return UrlAddress.base
    }
}

enum Parameter: String {
    case artistName = "term"
    case type = "entity"
}

enum Type: String {
    case album
    case musicVideo
    case musicTrack
}


final class ApiService {
    
    static func get(withResultType type: Type, forArtist artist: String, completion: @escaping ([NSDictionary]?) -> ()) {
        let stringUrl = UrlAddress.parameters(parameters: [Parameter.type: type.rawValue, Parameter.artistName: artist]).full
        guard let url = URL(string: stringUrl) else { return completion(nil) }
        
        NetworkManager.get(fromUrl: url) { (response) in
            guard let response = response as? NSDictionary,
                let result = response["results"] as? [NSDictionary] else {
                return completion(nil)
            }
            completion(result)
        }
    }
    
}
