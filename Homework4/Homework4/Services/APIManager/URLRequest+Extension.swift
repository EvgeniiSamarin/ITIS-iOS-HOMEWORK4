//
//  URLRequest+Extension.swift
//  Homework4
//
//  Created by Евгений Самарин on 02.11.2021.
//

import Foundation

public enum HTTPMethod: String {

    // MARK: - HTTP Methods

    case get = "GET"
    case post = "POST"
}

public extension URLRequest {

    // MARK: - Initializer

    init(components: URLComponents) {
        guard let url = components.url else {
            preconditionFailure("Unable to get URL from \(components)")
        }
        self = Self(url: url)
    }

    // MARK: - Instance methods

    private func map(_ transform: (inout Self) -> ()) -> Self {
        var request = self
        transform(&request)
        return request
    }

    func add(httpMethod: HTTPMethod) -> Self {
        self.map { $0.httpMethod = httpMethod.rawValue }
    }

    func add<Body: Encodable>(body: Body) -> Self {
        self.map {
            do {
                $0.httpBody = try JSONEncoder().encode(body)
            } catch {
                preconditionFailure("Failed to encode request body: \(body)")
            }
        }
    }

    func add(headers: [String: String]) -> Self {
        self.map {
            let allHTTPHeaderFields = $0.allHTTPHeaderFields ?? [:]

            let updatedAllHTTPHeaderFields = headers.merging(allHTTPHeaderFields, uniquingKeysWith:  { $1 })
            $0.allHTTPHeaderFields = updatedAllHTTPHeaderFields
        }
    }

    func add(body: [String: Any]) -> Self {
        self.map {
            do {
                let bodyData = try JSONSerialization.data(withJSONObject: body)
                $0.httpBody = bodyData
            } catch {
                preconditionFailure("Failed to serialize JSON Object: \(body)")
            }
        }
    }
}

extension URLRequest {

    // MARK: - API Methods

    static func getRandomFact() -> Self {
        Self(components: .fact())
            .add(httpMethod: .get)
            .add(headers: ["Accept": "application/json"])
    }

    static func getRandomImage() -> Self {
        Self.init(components: .dogImage())
            .add(httpMethod: .get)
    }
}
