//
//  URLComponents+Extension.swift
//  Homework4
//
//  Created by Евгений Самарин on 02.11.2021.
//

import Foundation

public extension URLComponents {

    init(scheme: String = "https",
         host: String = "catfact.ninja",
         path: String,
         queryItems: [URLQueryItem]? = nil) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        self = components
    }
}

extension URLComponents {

    static func fact() -> Self {
        let queryItems: [URLQueryItem] = [.init(name: "max_length", value: "140")]
        return Self(path: "/fact", queryItems: queryItems)
    }

    static func dogImage() -> Self {
        return Self(host: "dog.ceo", path: "/api/breeds/image/random/")
    }
}
