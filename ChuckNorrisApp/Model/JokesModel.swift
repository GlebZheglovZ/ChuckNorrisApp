//
//  JokesModel.swift
//  ChuckNorrisApp
//
//  Created by Глеб Николаев on 17.11.2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import Foundation

// MARK: - Information Model
struct Information: Decodable {
    let value: [Joke]
}

// MARK: - Joke Model
struct Joke: Decodable {
    let joke: String
}
