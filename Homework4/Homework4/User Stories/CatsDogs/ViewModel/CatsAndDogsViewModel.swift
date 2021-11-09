//
//  CatsAndDogsViewModel.swift
//  Homework4
//
//  Created by Евгений Самарин on 02.11.2021.
//

import Foundation
import Combine

final class CatsAndDogsViewModel {

    enum ContentType: Int {
        case cats
        case dogs
    }

    // MARK: - Instance Properties

    @Published var score: ScoreModel = ScoreModel()
    @Published var catsFact: String = "Content"
    @Published var dogsImage: String = "Content"

    var contentType: ContentType = .cats
    let errorResult = PassthroughSubject<Error, Never>()

    // MARK: -

    private var factsSubscriber: AnyCancellable?
    private var imagesSubscriber: AnyCancellable?

    // MARK: - Instance Methods

    func getContent() {
        switch self.contentType {
        case .cats:
            self.getCatFact()

        case .dogs:
            self.getDogsImage()
        }
    }

    func resetView() {
        self.catsFact = "Content"
        self.dogsImage = "Content"
        self.score.dogsScore = 0
        self.score.catsScore = 0
    }

    private func getCatFact() {
        self.factsSubscriber = APIManager.shared.getRandomCatFact()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorResult.send(error)

                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.catsFact = response.fact
                self?.score.catsScore += 1
            })
    }

    private func getDogsImage() {
        self.imagesSubscriber = APIManager.shared.getRandomDogImage()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorResult.send(error)

                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.dogsImage = response.message
                self?.score.dogsScore += 1
            })
    }
}
