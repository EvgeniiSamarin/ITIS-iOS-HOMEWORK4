//
//  APIManager.swift
//  Homework4
//
//  Created by Евгений Самарин on 03.11.2021.
//

import Foundation
import Combine

final class APIManager {

    static let shared = APIManager()

    func getRandomCatFact() -> AnyPublisher<CatResponse, Error> {
        let request: URLRequest = .getRandomFact()

        return URLSession.shared.fetch(for: request)
    }

    func getRandomDogImage() -> AnyPublisher<DogResponse, Error> {
        let request: URLRequest = .getRandomImage()

        return URLSession.shared.fetch(for: request)
    }
}
