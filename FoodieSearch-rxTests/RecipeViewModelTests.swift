//
//  FoodieSearch_rxTests.swift
//  FoodieSearch-rxTests
//
//  Created by Christian Leovido on 24/03/2020.
//  Copyright © 2020 Christian Leovido. All rights reserved.
//

import XCTest
import Moya
import RxTest
import RxSwift
import RxCocoa
@testable import FoodieSearch_rx

class RecipeViewModelTests: XCTestCase {

    var sut: RecipeViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        sut = nil
    }

    func testRecipeViewModelSuccess() {

        sut = RecipeViewModel(provider: makeMoyaStub(statusError: 200))
        sut.getRecipes(page: 1, ingredients: "", query: "")
    }

    func testRecipes() {

        sut = RecipeViewModel(provider: makeMoyaStub(statusError: 200))
        sut.getRecipes(page: 1, ingredients: "", query: "")

        let recipes = scheduler.createObserver([Recipe].self)

        sut.dataSource
            .bind(to: recipes)
            .disposed(by: disposeBag)

        scheduler.createColdObservable([.next(5, [Recipe(title: "One",
                                                         href: nil,
                                                         ingredients: "",
                                                         thumbnail: nil)]),
                                        .next(10, [Recipe(title: "Two",
                                                          href: nil,
                                                          ingredients: "",
                                                          thumbnail: nil)])
                                        ])
            .bind(to: sut.dataSource)
            .disposed(by: disposeBag)


        scheduler.start()

        XCTAssertEqual(recipes.events, [
            .next(0, []),
            .next(5, [Recipe(title: "One",
            href: nil,
            ingredients: "",
            thumbnail: nil)]),
            .next(10, [Recipe(title: "Two", href: nil, ingredients: "", thumbnail: nil)])
        ])

    }

    func testRecipeViewModelFailure() {

        sut = RecipeViewModel(provider: makeMoyaStub(statusError: 400))
        sut.getRecipes(page: 1, ingredients: "", query: "")

    }

}

private func makeMoyaStub<T: TargetType>(statusError: Int) -> MoyaProvider<T> {

    let bundle = Bundle(for: type(of: self) as! AnyClass)

    let url = bundle.url(forResource: "recipes", withExtension: "json")!
    let data = try! Data(contentsOf: url)

    let serverEndpointSuccess = { (target: T) -> Endpoint in
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(statusError, data) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    let serverStubSuccess = MoyaProvider<T>(
        endpointClosure: serverEndpointSuccess,
        stubClosure: MoyaProvider.immediatelyStub
    )

    return serverStubSuccess

}
