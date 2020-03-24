//
//  RecipeManager.swift
//  FoodieSearch-rx
//
//  Created by Christian Leovido on 24/03/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import RxMoya

struct RecipeViewModel {

    private let disposeBag = DisposeBag()
    private let provider: MoyaProvider<RecipeService> = MoyaProvider(plugins: [NetworkLoggerPlugin()])

    let recipes: BehaviorRelay<[Recipe]> = BehaviorRelay(value: [])
    let errorRecipesPublisher: PublishSubject<Error> = PublishSubject()

    func getRecipes(page: Int, ingredients: String, query: String) {

        provider.rx.request(.getRecipes(page: page, ingredients: ingredients, query: query))
            .debug("get recipes", trimOutput: true)
            .filterSuccessfulStatusAndRedirectCodes()
            .retry(2)
            .subscribe(onSuccess: { response in

                do {

                    let recipes = try response.map([Recipe].self, atKeyPath: "results")

                    self.recipes.accept(recipes)

                } catch let error {
                    self.errorRecipesPublisher.onNext(error)
                }

            }) { error in
                self.errorRecipesPublisher.onNext(error)
            }
        .disposed(by: disposeBag)

    }
}
