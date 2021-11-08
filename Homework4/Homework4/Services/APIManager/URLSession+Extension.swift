//
//  URLSession+Extension.swift
//  Homework4
//
//  Created by Евгений Самарин on 02.11.2021.
//

import Foundation
import Combine

public extension URLSession {

    func fetch<Response: Decodable>(for request: URLRequest) -> AnyPublisher<Response, Error> {
        dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

