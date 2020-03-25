//
//  RecipeError.swift
//  FoodieSearch-rx
//
//  Created by Christian Leovido on 25/03/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

enum RecipeError: Error {
    case decodingError(message: String)
    case unknown
}
