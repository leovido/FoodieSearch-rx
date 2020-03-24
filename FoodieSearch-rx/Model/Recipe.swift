//
//  Recipe.swift
//  FoodieSearch-rx
//
//  Created by Christian Leovido on 24/03/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation

struct Recipe: Decodable {
    var title: String
    var href: URL?
    var ingredients: String
    var thumbnail: String?
}
