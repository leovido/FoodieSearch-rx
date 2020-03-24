//
//  RecipeService.swift
//  FoodieSearch-rx
//
//  Created by Christian Leovido on 24/03/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation
import Moya

enum Constants: String {
    case BASE_URL = "https://recipe-puppy.p.rapidapi.com/"
    case HOST = "recipe-puppy.p.rapidapi.com"
    case APIKEY = "c565d1f793msh0079cbb1a51b966p120985jsn5c2d77e12299"
}

enum RecipeService {
    case getRecipes(page: Int, ingredients: String, query: String)
}

extension RecipeService: TargetType {
    var baseURL: URL {
        return URL(string: Constants.BASE_URL.rawValue)!
    }

    var path: String {
        return ""
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        Data()
    }

    var task: Task {
        switch self {
        case .getRecipes(let page, let ingredients, let query):

            var params = ["p": page,
                          "i": ingredients,
                          "q": query] as [String : Any]

            if ingredients.isEmpty {
                params.removeValue(forKey: "i")
            }

            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        ["x-rapidapi-host": Constants.HOST.rawValue,
         "x-rapidapi-key": Constants.APIKEY.rawValue]
    }


}
