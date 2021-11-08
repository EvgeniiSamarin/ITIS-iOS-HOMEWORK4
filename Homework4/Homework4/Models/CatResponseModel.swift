//
//  CatResponseModel.swift
//  Homework4
//
//  Created by Евгений Самарин on 03.11.2021.
//

import Foundation

struct CatResponse: Decodable {
    let fact: String
    let length: Int
}
