//
//  CatResponseModel.swift
//  Homework4
//
//  Created by Евгений Самарин on 03.11.2021.
//

import Foundation

struct CatResponse: Decodable {

    // MARK: - Instance Properties

    let fact: String
    let length: Int
}
