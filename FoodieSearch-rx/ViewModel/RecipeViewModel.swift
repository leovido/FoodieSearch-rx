//
//  RecipeViewModel.swift
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

struct RecipeViewModel: ViewModelBlueprint {

    typealias AnyService = RecipeService
    typealias Model = Recipe

    let disposeBag = DisposeBag()
    let provider: MoyaProvider<RecipeService>

    let dataSource: BehaviorRelay<[Recipe]> = BehaviorRelay(value: [])
    let errorDataSourcePublisher: PublishSubject<Error> = PublishSubject()

    init(provider: MoyaProvider<RecipeService> = MoyaProvider(plugins: [NetworkLoggerPlugin()])) {
        self.provider = provider
    }

    func getRecipes(page: Int, ingredients: String, query: String) {

        provider.rx.request(.getRecipes(page: page, ingredients: ingredients, query: query))
            .debug("get recipes", trimOutput: true)
            .filterSuccessfulStatusAndRedirectCodes()
            .retry(2)
            .subscribe({ event in
                switch event {
                case .success(let response):
                    self.decodeResponse(response: response)
                case .error(let error):
                    self.errorDataSourcePublisher.onNext(error)
                }
            })
        .disposed(by: disposeBag)

    }

    func decodeResponse(response: Response) {
        do {
            let recipes = try response.map([Recipe].self, atKeyPath: "results")
            self.dataSource.accept(recipes)
        } catch let error {
            self.errorDataSourcePublisher.onNext(error)
        }
    }
}
